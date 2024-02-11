// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';

contract Twitter is Ownable {
  struct Tweet {
    uint id;
    address author;
    string content;
    uint timestamp;
    bool isDeleted;
  }

  Tweet[] private _tweets;

  /**
   * This is the non-optimised way to get tweets by author
   */
  // mapping(address => Tweet[]) public _tweetsByAuthor;

  /**
   * A function to withdraw the contract's balance
   */
  function withdraw() external onlyOwner {
    address payable _owner = payable(owner());

    _owner.transfer(address(this).balance);
  }

  modifier isAuthor(uint _id) {
    require(_tweets[_id].author == msg.sender, 'You are not the author of this tweet');
    _;
  }

  modifier isNotDeleted(uint _id) {
    require(!_tweets[_id].isDeleted, 'The tweet is deleted');
    _;
  }

  /**
   * A function that allows users to create a new tweet
   * @param _content The content of the tweet
   */
  function createTweet(string memory _content) external {
    Tweet memory newTweet = Tweet(_tweets.length, msg.sender, _content, block.timestamp, false);

    _tweets.push(newTweet);

    /**
     * This is the non-optimised way to get tweets by author
     */
    // _tweetsByAuthor[msg.sender].push(newTweet);
  }

  /**
   * A function to get all the tweets from a given author
   * @param _author The address of the author whom we want to get the tweets
   */
  function getTweetByAuthor(address _author) external view returns (Tweet[] memory) {
    Tweet[] memory tweetsByAuthor = new Tweet[](_tweets.length);
    uint j = 0;

    for (uint i = 0; i < _tweets.length; i++) {
      if (_tweets[i].author != _author) {
        tweetsByAuthor[j] = _tweets[i];
        j++;
      }
    }

    return tweetsByAuthor;
  }

  /**
   * This is the non-optimised way to get tweets by author
   */
  // function getTweetByAuthor2(
  //   address _author
  // ) external view returns (Tweet[] memory) {
  //   return _tweetsByAuthor[_author];
  // }

  /**
   * A function to get all the non-deleted tweets
   */
  function getTweets() external view returns (Tweet[] memory) {
    uint nonDeletedTweetsCount = 0;

    for (uint i = 0; i < _tweets.length; i++) {
      if (!_tweets[i].isDeleted) {
        nonDeletedTweetsCount++;
      }
    }

    Tweet[] memory nonDeletedTweets = new Tweet[](nonDeletedTweetsCount);
    uint j = 0;

    for (uint i = 0; i < _tweets.length; i++) {
      if (!_tweets[i].isDeleted) {
        nonDeletedTweets[j] = _tweets[i];
        j++;
      }
    }

    return nonDeletedTweets;
  }

  /**
   * A function to edit a tweet
   * @param _id The id of the tweet to edit
   */
  function editTweet(uint _id, string memory _newContent) external isAuthor(_id) isNotDeleted(_id) {
    _tweets[_id].content = _newContent;
  }

  /**
   * A function to delete a tweet
   * @param _id The id of the tweet to delete
   */
  function deleteTweet(uint _id) external isAuthor(_id) isNotDeleted(_id) {
    _tweets[_id].isDeleted = true;
  }
}
