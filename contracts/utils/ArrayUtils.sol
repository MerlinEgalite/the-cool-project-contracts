/*
 * SPDX-License-Identifier:    MIT
 */

pragma solidity >=0.6.12;


library ArrayUtils {

    function deleteItem(uint256[] storage self, uint256 item) internal returns (bool) {
        uint256 length = self.length;
        for (uint256 i = 0; i < length; i++) {
            if (self[i] == item) {
                // Move the last element into the place to delete
                self[i] = self[length -1];
                self.pop();
                return true;
            }
        }
        return false;
    }


    function contains(uint256[] storage self, uint256 item) internal view returns (bool) {
        for (uint256 i = 0; i < self.length; i++) {
            if (self[i] == item) {
                return true;
            }
        }
        return false;
    }
}