// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../contracts/PrivateAccessToken.sol";

contract PrivateAccessTokenTest is Test {
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    PrivateAccessToken t;

    function setUp() public {
        vm.prank(alice);
        t = new PrivateAccessToken("demo-data", "uri");
    }

    function test_TokenHolderCanCallViewData() public {
        vm.prank(alice);
        assertEq(t.ViewData(), "demo-data");
    }

    function test_NonHolderCannotCallViewData() public {
        vm.prank(bob);
        vm.expectRevert();
        t.ViewData();
    }

    function test_AccessMovesWithTheToken() public {
        vm.prank(alice);
        t.safeTransferFrom(alice, bob, 0, 1, "");
        vm.prank(bob);
        assertEq(t.ViewData(), "demo-data");
    }

    /// `private` limits other contracts. Anyone reading chain state can still see the value.
    function test_DataIsReadableFromStorageWithoutTheToken() public view {
        bytes32 slot = vm.load(address(t), bytes32(uint256(3)));
        assertEq(bytes9(slot), bytes9("demo-data"));
    }
}
