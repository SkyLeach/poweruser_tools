# Reddit Comment Analyzer

A multi-function utility to make browsing reddit far more powerful in the browser, specifically firefox.

## Primary Objectives

Provide a simple interface for the average user to powerful tools that make participation in threads at a high level intuitive.  Provide the user with the ability to quickly reference metadata about a thread, similar threads, historical meta-iformation, source tracing and much more.  The list of functionality below is what the script currently does or functions under development or already planned for development.

* Comment Data Visualisation
* Comment Data Summarization
* Comment Data Statistical Summary information.
* In-Browser NLP across all comments.
* In-Broswer Reddit API access
* Background processing of extended discussion information for on-demand access using worker threads.

### Secondary Objectives

Assist more advanced users with validation, debugging and user-supervision of machine learning projects.

* Interactive access between active browsing session and localhost back-end WSGI Python instance(s).
* Provide an in-browser hook for inserting training data.
* Provide an in-browser comparison of before/after results when information is added to a training set or a training set is applied to the currently active page.
    * It is anticipated that this will be very useful for NLU tasks
    * this space to be filled later...
* Add more MLA topics here...

The ML applications are being worked out as I decide how far to take this.  I know I want to compare results from NLU in-browser, but I'm not sure if I will also be adding cRNN-based image analytics in my version.  Others may also wish to expand this userscript.
