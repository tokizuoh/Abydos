package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	_ = godotenv.Load()

	projectName := os.Getenv("SCRAPBOX_FULL_PROJECT_NAME")
	url := fmt.Sprintf("https://scrapbox.io/api/pages/%s/", projectName)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Panicln(err)
	}
	log.Println(url)
	csid := os.Getenv("CONNECT_SID")
	cookie := http.Cookie{
		Name:  "connect.sid",
		Value: csid,
	}
	req.AddCookie(&cookie)
	client := new(http.Client)

	resp, err := client.Do(req)
	if err != nil {
		log.Panicln(resp)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Panicln(resp)
	}

	var jsonBody map[string]interface{}
	if err = json.Unmarshal(body, &jsonBody); err != nil {
		log.Panicln(err)
	}

	log.Println(jsonBody)

}
