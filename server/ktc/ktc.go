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
					"src": "https://dstore.co.th/wp-content/uploads/2018/06/logo-ktc.png"
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
		"title": "List View Testing",
		"body": {
			"type": "list",
			"children": [
				{
					"type": "row",
					"children" : [
						{
							"type":"link",
							"to":"0",
							"text":"Previous"
						},
						{
							"type":"submit",
							"to" : "2",
							"text":"submit"
						}
					]
				},
				{
					"type": "image",
					"src": "https://www.ktc.co.th/pub/media/creditcard/03-KTC_X_WORLD_REWARDS_MASTERCARD.png"
				},
				{
					"type": "image",
					"src": "https://www.ktc.co.th/pub/media/creditcard/04-KTC_WORLD_REWARDS_MASTERCARD.png"
				},
				{
					"type": "image",
					"src": "https://www.ktc.co.th/sites/ktc/thumbnail/1491904147244/02-ktc%20visa%20signature-min.png"
				},
				{
					"type": "image",
					"src": "https://www.ktc.co.th/pub/media/creditcard/03-KTC_X_WORLD_REWARDS_MASTERCARD.png"
				},
				{
					"type": "image",
					"src": "https://www.ktc.co.th/pub/media/creditcard/04-KTC_WORLD_REWARDS_MASTERCARD.png"
				},
				{
					"type": "image",
					"src": "https://www.ktc.co.th/sites/ktc/thumbnail/1491904147244/02-ktc%20visa%20signature-min.png"
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
							"text":"Previous"
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
		sub, err := nc.SubscribeSync("ktc.0")
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
		sub, err := nc.SubscribeSync("ktc.1")
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
		sub, err := nc.SubscribeSync("ktc.2")
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
