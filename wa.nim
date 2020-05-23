import os, strutils, httpClient, strformat, json, uri

proc get_app_id(): string =
    const appid_path = getHomeDir() & ".wolfram_appid"
    if existsFile(appid_path):
        return readFile(appid_path)
    else:
        echo fmt"No AppID found in {appid_path}. "
        echo "Get one from here: http://products.wolframalpha.com/api/"
        echo "Enter AppID:"
        let new_app_id = readLine(stdin)
        writeFile(appid_path, new_app_id)
        echo fmt"AppID saved to {appid_path}"
        return new_app_id

let appid = get_app_id()

if paramCount() == 0:
    echo "Wolfram Alpha CLI"
    echo "Usage: wa <query>"
    quit()

var query = join(commandLineParams(), sep=" ")

query = encodeUrl(query, false)
if query.len == 0:
    quit("Query was empty")

var client = newHttpClient()

let url = fmt"http://api.wolframalpha.com/v2/query?appid={appid}&input={query}&format=plaintext&output=json"

let response = client.request(url, httpMethod=HttPGet)

if response.status != Http200:
    quit(fmt"Response status was {response.status}")

let queryResult = parseJson(response.body())["queryresult"]

if queryResult.getOrDefault("success").getBool(default = false):
    for pod in  queryResult["pods"].getElems():
        let title = pod["title"].getStr().strip()
        var title_printed = false
        for subpod in pod["subpods"].getElems():
            let plaintext = subpod["plaintext"].getStr().strip()

            if plaintext.len == 0: continue
            if title.len != 0 and not title_printed: 
                echo title & ":"
                title_printed = true
            echo "\t" & plaintext.replace("\n", "\n\t")
else:
    echo "Query was not successful"
    if queryResult["error"].hasKey("msg"):
        echo queryResult["error"]["msg"].getStr()
    if queryResult.hasKey("tips"):
        echo queryResult["tips"]["text"].getStr()
