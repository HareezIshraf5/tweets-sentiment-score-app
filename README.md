# FeelTweet

A mobile app that provide approximate sentiment score to 200 latest public tweets.

## FireBase Authentication & Database

## Application Programming Interface (API)
### Hosted Server
We hosted our own Python script with Flask using Heroku. ([access  here](https://github.com/aminnurrasyid/tweet-sentimentscore-api))<br>
This script requests tweets from Twitter API and process texts which output an approximate sentiment score out of it.<br>

### Twitter API
We utilized this API to get the latest 200 public tweets from Twitter that contain a specified keyword (will be queried by User).<br>
Tweets are filtered to **only English tweets and non-retweet tweets**.
## Sentiment Score Formula

Sentiment Score is depicted as scale from -2 to +2. The scale can be interpreted as follows:
* Sentiment Score towards -2 meaning that people react to the keyword **NEGATIVELY**.
* Sentiment Score towards +2 meaning that people react to the keyword **POSITIVELY**.
* Sentiment Score on 0 meaning that people react to the keyword **NEUTRALLY**.

#### Algorithm
1. Any occurence of Positive word and Negative word will be initialized as a ***scalar***.<br>
2. Any occurence of Booster words will be calculated as the ***magnitude***.<br>
3. Any occurence of Negation words will be ***counter the polarity*** at the end of the calculation.<br>
4. At the end average of the score from 200 tweets are normalized to the specified scale.

The corpus can be found in the hosted github repository.

## UI - fahmi

## UI - haziq
