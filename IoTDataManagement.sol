// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IotDataInterface {
    function getDatasetScore(uint256, IERC20) external view returns (uint);
}

contract IoTDataManagement {
    IotDataInterface externalContract;

    struct User {
        uint256[] preferences;
        address wallet;
    }

    mapping(uint256 => User) public users;
    mapping(address => bool) public authorizedUsers;
    IERC20 public token;

    constructor(IERC20 _token, address _externalContract) {
        token = _token;
        externalContract = IotDataInterface(_externalContract);
    }

    function authoriseUser(address _user) public {
        authorizedUsers[_user] = true;
    }

    function deauthoriseUser(address _user) public {
        authorizedUsers[_user] = false;
    }

    function setPreferences(uint256[] memory preferences) public {
        require(authorizedUsers[msg.sender], "User not authorized");
        users[preferences[0]].preferences = preferences;
    }

    function getRecommendation(uint256 _userId) public view returns (uint256) {
        require(authorizedUsers[msg.sender], "User not authorized");
        uint256[] memory userPreferences = users[_userId].preferences;
        uint256 maxScore = 0;
        uint256 recommendedData = 0;
        for (uint256 i = 0; i < userPreferences.length; i++) {
            uint256 score = externalContract.getDatasetScore(userPreferences[i], token);

            if (score > maxScore) {
                maxScore = score;
                recommendedData = userPreferences[i];
            }
        }
        return recommendedData;
    }
}
