# FeelTweets
A mobile app that provide approximate sentiment score to 200 latest public tweets.

![image](https://user-images.githubusercontent.com/57680454/215766499-1e120cdf-1a83-4087-8e7d-5a96c537cf7c.png)

### Group Members
1. AMIN NUR RASYID BIN ZULKIFLI (1919555)
2. HAREEZ ISHRAF BIN HAZRUDDEN (1911923)
3. ABDUL HAZIQ BIN ZULKIFLI (1917923)
4. MUHAMMAD FAHMI FAKHIR (1811481)

## Compilation & Running Instruction 
1. E

## FireBase Authentication & Database
* We utilized FireBase as our database storage to store all the information the users.
* The Authentication process utilized the FireBase where it retrieves the email and the password of the users.
* The search and tweets history entered by the users can be be retrieved from the FireBase according to the users UID once the users logged in.

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
