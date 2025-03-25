
BROWSER_TIMEOUT = "40"
BROWSER = "chromium"
HEADLESS = False
RESOLUTION_HEIGHT = "1366"
RESOLUTION_WIDTH = "768"
MOBILE = False
DEVICE_NAME = "Nexus 5"

PIPELINE = False
ENVIRONMENT = "UAT"

URLS = {
    'DEV': 'https://demoqa.com/',
    'UAT': 'https://demoqa.com/',
    'RC': 'https://demoqa.com/',
    'PROD': 'https://demoqa.com/'
}


LANG = "PT"
# LANGUAGE_DIC = {
#     'PT': 'pt',
#     'MX': 'mx',
#     'CO': 'co',
#     'AR': 'ar'
# }


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
