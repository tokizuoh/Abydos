package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/joho/godotenv"
)

type PagesResponse struct {
	ProjectName string `json:"projectName"`
	Skip        int    `json:"skip"`
	Limit       int    `json:"limit"`
	Count       int    `json:"count"`
	Pages       []struct {
		ID           string   `json:"id"`
		Title        string   `json:"title"`
		Image        string   `json:"image"`
		Descriptions []string `json:"descriptions"`
		User         struct {
			ID string `json:"id"`
		} `json:"user"`
		Pin             int64  `json:"pin"`
		Views           int    `json:"views"`
		Linked          int    `json:"linked"`
		CommitID        string `json:"commitId"`
		Created         int    `json:"created"`
		Updated         int    `json:"updated"`
		Accessed        int    `json:"accessed"`
		SnapshotCreated int    `json:"snapshotCreated"`
		PageRank        int    `json:"pageRank"`
	} `json:"pages"`
}

var targetTag string = "#book"
var excludedTag string = "#読了"
var excludedTitle string = "Terminal: Book"

func getBookTitle() (string, error) {
	projectName := os.Getenv("SCRAPBOX_FULL_PROJECT_NAME")
	limit := 50
	url := fmt.Sprintf("https://scrapbox.io/api/pages/%s/?limit=%d", projectName, limit)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return "", err
	}

	csid := os.Getenv("CONNECT_SID")
	cookie := http.Cookie{
		Name:  "connect.sid",
		Value: csid,
	}
	req.AddCookie(&cookie)
	client := new(http.Client)

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var pr PagesResponse
	if err = json.Unmarshal(body, &pr); err != nil {
		return "", err
	}

	var bookTitle string
	updated := 0
	for _, page := range pr.Pages {
		for _, description := range page.Descriptions {
			if page.Title != excludedTitle && strings.Contains(description, targetTag) && !strings.Contains(description, excludedTag) {
				if page.Updated > updated {
					bookTitle = page.Title
					updated = page.Updated
				}
			}
		}
	}

	if bookTitle == "" {
		// TODO: 終了コードを指定して且つdeferを実行させて終了させたい
		// ref: https://budougumi0617.github.io/2021/06/30/which_termination_method_should_choose_on_go/
		return "", fmt.Errorf("最近本読んでないね？")
	}

	return bookTitle, nil
}

func createTextFile(text string) error {
	f, err := os.Create("title.txt")
	if err != nil {
		return err
	}
	defer f.Close()

	_, err = f.WriteString(text)
	if err != nil {
		return err
	}

	return nil
}

func main() {
	_ = godotenv.Load()

	bookTitle, err := getBookTitle()
	if err != nil {
		log.Panicln(err)
	}

	err = createTextFile(bookTitle)
	if err != nil {
		log.Panicln(err)
	}
}
