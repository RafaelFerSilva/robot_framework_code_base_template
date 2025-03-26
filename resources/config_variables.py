DB_API_MODULE_NAME="pymysql"
BROWSER_TIMEOUT = "40"
BROWSER = "chromium"
HEADLESS = False

PIPELINE = False
ENVIRONMENT = "UAT"

URLS = {
    'DEV': 'https://demoqa.com/',
    'UAT': 'https://demoqa.com/',
    'RC': 'https://demoqa.com/',
    'PROD': 'https://demoqa.com/'
}


LANG = "pt"

MOBILE = False
DEVICE_NAME = "Nexus 5"

NEW_CONTEXT = {
    "acceptDownloads": True,
    "bypassCSP": False,
    "forcedColors": "none",
    "ignoreHTTPSErrors": False,
    "javaScriptEnabled": True,
    "offline": False,
    "reducedMotion": "no-preference",
    "serviceWorkers": "allow",
    "locale": None,
    "userAgent": None
}
