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
					"src": "https://km.visamiddleeast.com/dam/VCOM/regional/ap/taiwan/global-elements/images/tw-visa-classic-card-498x280.png"
				},
				{
					"type": "image",
					"src": "https://km.visamiddleeast.com/dam/VCOM/regional/ap/taiwan/global-elements/images/tw-visa-classic-card-498x280.png"
				},
				{
					"type": "image",
					"src": "https://km.visamiddleeast.com/dam/VCOM/regional/ap/taiwan/global-elements/images/tw-visa-classic-card-498x280.png"
				},
				{
					"type": "image",
					"src": "https://km.visamiddleeast.com/dam/VCOM/regional/ap/taiwan/global-elements/images/tw-visa-classic-card-498x280.png"
				},
				{
					"type": "image",
					"src": "https://km.visamiddleeast.com/dam/VCOM/regional/ap/taiwan/global-elements/images/tw-visa-classic-card-498x280.png"
				},
				{
					"type": "image",
					"src": "https://km.visamiddleeast.com/dam/VCOM/regional/ap/taiwan/global-elements/images/tw-visa-classic-card-498x280.png"
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
