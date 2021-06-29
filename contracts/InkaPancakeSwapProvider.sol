// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.6.12;

import "./utils/Ownable.sol";
import "./bsc/interfaces/IPancakeFactory.sol";
import "./bsc/libraries/PancakeLibrary.sol";
import './libraries/TransferHelper.sol';
import "./bsc/interfaces/IWBNB.sol";
import "./bsc/interfaces/IBEP20.sol";
import "./libraries/SafeMath.sol";
import "./libraries/Convert.sol";

contract InkaPancakeSwapProvider is Ownable {
    using SafeMath for uint256;
    using Convert for bytes;

    event InkaSwapOperation (
        uint256 amountOut,
        uint256 fee
    );

    address public WBNB;
    address public pancakeFactory;

    uint256 public providerFee = 3 * 10 ** 7; 
    uint256 public constant FEE_DENOMINATOR = 10 ** 10;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'InkaPancakeSwapProvider: EXPIRED');
        _;
    }

    constructor (
        address _wbnb,
        address _factory
    ) public {
        require(_wbnb != address(0), "InkaPancakeSwapProvider: ZERO_WBNB_ADDRESS");
        require(_factory != address(0), "InkaPancakeSwapProvider: ZERO_FACTORY_ADDRESS");

        WBNB = _wbnb;
        pancakeFactory = _factory;
    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint swapAmountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual ensure(deadline) {
        uint amountOut = _swapExactTokensForTokensSupportingFeeOnTransferTokens(amountIn, swapAmountOutMin, path);
        uint feeAmount = amountOut.mul(providerFee).div(FEE_DENOMINATOR);

        emit InkaSwapOperation(amountOut, feeAmount);

        uint adjustedAmountOut = amountOut.sub(feeAmount);
        TransferHelper.safeTransfer(path[path.length - 1], to, adjustedAmountOut);
    }

    function _swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path
    ) internal virtual returns (uint) {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, PancakeLibrary.pairFor(pancakeFactory, path[0], path[1]), amountIn
        );
        uint balanceBefore = IBEP20(path[path.length - 1]).balanceOf(address(this));
        _swapSupportingFeeOnTransferTokens(path, address(this));
        uint amountOut = IBEP20(path[path.length - 1]).balanceOf(address(this)).sub(balanceBefore);
        require(amountOut >= amountOutMin, 'InkaPancakeSwapProvider: INSUFFICIENT_OUTPUT_AMOUNT');
        return amountOut;
    }

    function swapExactBNBForTokensSupportingFeeOnTransferTokens(
        uint swapAmountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual payable ensure(deadline) {
        uint amountOut = _swapExactBNBForTokensSupportingFeeOnTransferTokens(swapAmountOutMin, path, 0);
        uint feeAmount = amountOut.mul(providerFee).div(FEE_DENOMINATOR);

        emit InkaSwapOperation(amountOut, feeAmount);

        uint adjustedAmountOut = amountOut.sub(feeAmount);
        TransferHelper.safeTransfer(path[path.length - 1], to, adjustedAmountOut);
    }

    function _swapExactBNBForTokensSupportingFeeOnTransferTokens(
        uint swapAmountOutMin,
        address[] calldata path,
        uint fee
    ) internal virtual returns (uint) {
        require(path[0] == WBNB, 'InkaPancakeSwapProvider: INVALID_PATH');
        uint amountIn = msg.value.sub(fee);
        require(amountIn > 0, 'InkaPancakeSwapProvider: INSUFFICIENT_INPUT_AMOUNT');
        IWBNB(WBNB).deposit{value: amountIn}();
        assert(IWBNB(WBNB).transfer(PancakeLibrary.pairFor(pancakeFactory, path[0], path[1]), amountIn));
        uint balanceBefore = IBEP20(path[path.length - 1]).balanceOf(address(this));
        _swapSupportingFeeOnTransferTokens(path, address(this));
        uint amountOut = IBEP20(path[path.length - 1]).balanceOf(address(this)).sub(balanceBefore);
        require(amountOut >= swapAmountOutMin, 'InkaPancakeSwapProvider: INSUFFICIENT_OUTPUT_AMOUNT');
        return amountOut;
    }

    function swapExactTokensForBNBSupportingFeeOnTransferTokens(
        uint amountIn,
        uint swapAmountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual ensure(deadline) {
        uint amountOut = _swapExactTokensForBNBSupportingFeeOnTransferTokens(amountIn, swapAmountOutMin, path);
        uint feeAmount = amountOut.mul(providerFee).div(FEE_DENOMINATOR);

        emit InkaSwapOperation(amountOut, feeAmount);

        IWBNB(WBNB).withdraw(amountOut);
        uint adjustedAmountOut = amountOut.sub(feeAmount);
        TransferHelper.safeTransferETH(to, adjustedAmountOut);
    }

    function _swapExactTokensForBNBSupportingFeeOnTransferTokens(
        uint amountIn,
        uint swapAmountOutMin,
        address[] calldata path
    ) internal virtual returns (uint) {
        require(path[path.length - 1] == WBNB, 'InkaPancakeSwapProvider: INVALID_PATH');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, PancakeLibrary.pairFor(pancakeFactory, path[0], path[1]), amountIn
        );
        uint balanceBefore = IBEP20(WBNB).balanceOf(address(this));
        _swapSupportingFeeOnTransferTokens(path, address(this));
        uint amountOut = IBEP20(WBNB).balanceOf(address(this)).sub(balanceBefore);
        require(amountOut >= swapAmountOutMin, 'InkaPancakeSwapProvider: INSUFFICIENT_OUTPUT_AMOUNT');
        return amountOut;
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pair
    function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = PancakeLibrary.sortTokens(input, output);
            require(IPancakeFactory(pancakeFactory).getPair(input, output) != address(0), "InkaPancakeSwapProvider: PAIR_NOT_EXIST");
            IPancakePair pair = IPancakePair(PancakeLibrary.pairFor(pancakeFactory, input, output));
            uint amountInput;
            uint amountOutput;
            { // scope to avoid stack too deep errors
            (uint reserve0, uint reserve1,) = pair.getReserves();
            (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
            amountInput = IBEP20(input).balanceOf(address(pair)).sub(reserveInput);
            amountOutput = PancakeLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
            }
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
            address to = i < path.length - 2 ? PancakeLibrary.pairFor(pancakeFactory, output, path[i + 2]) : _to;
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    receive() external payable { }

    function withdraw(address token) external {
        if (token == WBNB) {
            uint256 wethBalance = IBEP20(token).balanceOf(address(this));
            if (wethBalance > 0) {
                IWBNB(WBNB).withdraw(wethBalance);
            }
            TransferHelper.safeTransferETH(owner(), address(this).balance);
        } else {
            TransferHelper.safeTransfer(token, owner(), IBEP20(token).balanceOf(address(this)));
        }
    }

    function setProviderFee(uint _fee) external onlyOwner {
        providerFee = _fee;
    }

    function setPancakeFactory(address _factory) external onlyOwner {
        pancakeFactory = _factory;
    }

    function setWBNB(address _wbnb) external onlyOwner {
        WBNB = _wbnb;
    }
}
