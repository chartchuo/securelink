package main

import (
	"fmt"
	"log"
	"time"

	nats "github.com/nats-io/nats.go"
)

func main() {
	page0 := `
	{
		"type": "page",
		"title": "Page 0",
		"body": {
			"type": "column",
			"children": [
				{
					"type": "image",
					"src": "https://www.kpi.co.th/src/nav-logo.png"
				},
				{
					"type": "textField",
					"hintText" : "First name",
					"id": "firstName"
				},
				{
					"type": "textField",
					"hintText" : "Last name",
					"id": "lastName"
				},
				{
					"type": "text",
					"text": "Please input your name and last name"
				},
				{
					"type": "link",
					"to" : "1",
					"text": "Next"
				}
			]
		}
	}
	`
	page1 := `
	{
		"type": "page",
		"title": "Page 1",
		"body": {
			"type": "column",
			"children": [
				{
					"type": "text",
					"text": "Input your address"
				},
				{
					"type": "textField",
					"hintText" : "Address",
					"id": "address"
				},
				{
					"type": "row",
					"children" : [
						{
							"type":"link",
							"to":"0",
							"text":"Preious"
						},
						{
							"type":"submit",
							"to" : "2",
							"text":"submit"
						}
					]
				}
			]
		}
	}
	`
	page2 := `
	{
		"type": "page",
		"title": "Page 2",
		"body": {
			"type": "column",
			"children": [
				{
					"type": "text",
					"text": "%v"
				},
				{
					"type": "row",
					"children" : [
						{
							"type":"link",
							"to":"1",
							"text":"Preious"
						},
						{
							"type":"done",
							"text":"done"
						}
					]
				}
			]
		}
	}
	`

	nc, err := nats.Connect(nats.DefaultURL)
	if err != nil {
		log.Fatal(err)
	}
	defer nc.Close()

	go func() {
		sub, err := nc.SubscribeSync("kpi.0")
		if err != nil {
			log.Fatal(err)
		}
		for {
			msg, err := sub.NextMsg(10 * time.Hour)
			if err != nil {
				log.Fatal(err)
			}
			b := []byte(page0)
			print("Respond: Page 0\n")
			msg.Respond(b)
		}

	}()

	go func() {
		sub, err := nc.SubscribeSync("kpi.1")
		if err != nil {
			log.Fatal(err)
		}
		for {
			msg, err := sub.NextMsg(10 * time.Hour)
			if err != nil {
				log.Fatal(err)
			}
			b := []byte(page1)
			print("Respond: Page 1\n")
			msg.Respond(b)
		}

	}()

	go func() {
		sub, err := nc.SubscribeSync("kpi.2")
		if err != nil {
			log.Fatal(err)
		}
		for {
			msg, err := sub.NextMsg(10 * time.Hour)
			if err != nil {
				log.Fatal(err)
			}
			print("Receive Data: ", string(msg.Data), "\n")
			res := fmt.Sprintf(page2, string(msg.Data))
			b := []byte(res)
			print("Respond: Page 2\n")
			msg.Respond(b)
		}

	}()

	time.Sleep(10 * time.Hour)

}
