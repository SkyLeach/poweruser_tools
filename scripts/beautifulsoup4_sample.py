import bs4, requests

query = "soup"

response = requests.get("https://pypi.org/search/?", {"q": query})
html = response.content
bs = bs4.BeautifulSoup(html)
pkg_els = list(bs.select(".package-snippet"))

pfx = "package-snippet__"
info_list = [dict((fld, pkg_el.select(f".{pfx}{fld}")[0].text.strip().split("\n\n")[0]) for fld in ("title", "name", "version", "released", "description")) for pkg_el in pkg_els]
info = dict((i["name"],i) for i in info_list)

print(info)
