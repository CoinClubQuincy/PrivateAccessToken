// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../contracts/PrivateAccessToken.sol";

contract PrivateAccessTokenTest is Test {
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    bytes32 constant HASH = keccak256("salted document");
    PrivateAccessToken t;

    function setUp() public {
        vm.prank(alice);
        t = new PrivateAccessToken(HASH, "ipfs://encrypted", "uri");
    }

    function test_ConstructorRequiresAHashAndALink() public {
        vm.expectRevert("data hash is required");
        new PrivateAccessToken(bytes32(0), "ipfs://encrypted", "uri");
        vm.expectRevert("encrypted data link is required");
        new PrivateAccessToken(HASH, "", "uri");
    }

    function test_TokenHolderCanCallViewData() public {
        vm.prank(alice);
        (bytes32 h, string memory link) = t.ViewData();
        assertEq(h, HASH);
        assertEq(link, "ipfs://encrypted");
    }

    function test_NonHolderCannotCallViewData() public {
        vm.prank(bob);
        vm.expectRevert("only the token holder can access");
        t.ViewData();
    }

    function test_AccessMovesWithTheToken() public {
        vm.prank(alice);
        t.safeTransferFrom(alice, bob, 0, 1, "");
        vm.prank(bob);
        (bytes32 h, ) = t.ViewData();
        assertEq(h, HASH);
        vm.prank(alice);
        vm.expectRevert("only the token holder can access");
        t.ViewData();
    }

    function test_AnyoneCanVerifyData() public {
        vm.startPrank(bob);
        assertTrue(t.verifyData(HASH));
        assertFalse(t.verifyData(keccak256("other document")));
        vm.stopPrank();
    }

    function test_ViewStatusReportsTheCallersBalance() public {
        vm.prank(alice);
        assertEq(t.ViewStatus(), 1);
        vm.prank(bob);
        assertEq(t.ViewStatus(), 0);
    }

    /// The gate on ViewData does not hide stored values. That is why only a hash goes on-chain.
    function test_TheStoredHashIsReadableWithoutTheToken() public view {
        assertEq(vm.load(address(t), bytes32(uint256(3))), HASH);
    }
}
