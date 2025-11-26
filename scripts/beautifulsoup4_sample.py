import os
import time
import bs4
from selenium import webdriver
#  from selenium.webdriver.firefox.service import Service
from selenium.webdriver.firefox.options import Options


def main():
    query = "soup"

    # Configure Firefox options to use your default profile
    firefox_options = Options()
    firefox_options.add_argument("--profile")
    firefox_options.add_argument(
            os.path.join(os.environ['APPDATA'],
            r"\Mozilla\Firefox\Profiles\5wjx7aqn.default-release"))
    #  firefox_options.add_argument(
    #          os.path.join(*["Users", "mattg", "AppData", "Local",
    #                         "Mozilla", "Firefox", "Profiles",
    #                         "5wjx7aqn.default-release"]))

    # You can also let Firefox use the default profile automatically
    # firefox_options.add_argument("--profile")
    # firefox_options.add_argument(r"C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles\*.default")

    # Initialize Firefox driver
    driver = webdriver.Firefox(options=firefox_options)

    try:
        # Navigate to PyPI search
        driver.get(f"https://pypi.org/search/?q={query}")

        # Wait for JavaScript to load (adjust time as needed)
        time.sleep(3)

        # Get the page source after JavaScript execution
        html = driver.page_source
        bs = bs4.BeautifulSoup(html)
        pkg_els = list(bs.select(".package-snippet"))

        pfx = "package-snippet__"
        info_list = [dict((fld, pkg_el.select(
        f".{pfx}{fld}")[0].text.strip().split("\n\n")[0]) for fld in (
            "title", "name", "version", "released", "description")
                                            ) for pkg_el in pkg_els]
        info = dict((i["name"], i) for i in info_list)

        print(info)

    finally:
        driver.quit()

# Run the function
if __name__ == "__main__":
    main()
