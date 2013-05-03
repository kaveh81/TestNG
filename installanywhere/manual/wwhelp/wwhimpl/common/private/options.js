// Copyright (c) 2001-2003 Quadralay Corporation.  All rights reserved.
//

function  WWHCommonSettings_Object()
{
  this.mTitle = "InstallAnywhere 8.0 Help Library";

  this.mbCookies            = true;
  this.mCookiesDaysToExpire = 30;
  this.mCookiesID           = "ETEPHNSS";

  this.mAccessible       = "false";
  this.mbForceJavaScript = false;

  this.mbSyncContentsEnabled  = true;
  this.mbPrevEnabled          = true;
  this.mbNextEnabled          = true;
  this.mbRelatedTopicsEnabled = false;
  this.mbEmailEnabled         = true;
  this.mbPrintEnabled         = true;
  this.mbBookmarkEnabled      = false;

  this.mEmailAddress = "support@macrovision.com";

  this.mRelatedTopics = new WWHCommonSettings_RelatedTopics_Object();
  this.mALinks        = new WWHCommonSettings_ALinks_Object();
  this.mPopup         = new WWHCommonSettings_Popup_Object();

  this.mbHighlightingEnabled        = true;
  this.mHighlightingForegroundColor = "#000000";
  this.mHighlightingBackgroundColor = "#ECF1F8";
}

function  WWHCommonSettings_RelatedTopics_Object()
{
  this.mWidth = 250;

  this.mTitleFontStyle       = "font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mTitleForegroundColor = "#FFFFFF";
  this.mTitleBackgroundColor = "#999999";

  this.mFontStyle       = "font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mForegroundColor = "#ECF1F8";
  this.mBackgroundColor = "#FFFFFF";
  this.mBorderColor     = "#666666";

  this.mbInlineEnabled = false;
  this.mInlineFontStyle = "font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mInlineForegroundColor = "#ECF1F8";
}

function  WWHCommonSettings_ALinks_Object()
{
  this.mbShowBook = false;

  this.mWidth  = 250;
  this.mIndent = 17;

  this.mTitleFontStyle       = "font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mTitleForegroundColor = "#FFFFFF";
  this.mTitleBackgroundColor = "#999999";

  this.mFontStyle       = "font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif ; font-size: 8pt";
  this.mForegroundColor = "#ECF1F8";
  this.mBackgroundColor = "#FFFFFF";
  this.mBorderColor     = "#666666";
}

function  WWHCommonSettings_Popup_Object()
{
  this.mWidth = 200;

  this.mBackgroundColor = "#ECF1F8";
  this.mBorderColor     = "#999999";
}
