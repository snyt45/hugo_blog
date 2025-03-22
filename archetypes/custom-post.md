---
title: "{{ replace .Name "-" " " | title }}"
description: 
slug: "{{ os.Getenv "HUGO_CUSTOM_SLUG" | default .Name }}"
date: {{ with os.Getenv "HUGO_CUSTOM_DATE" }}{{ . }}{{ else }}{{ .Date }}{{ end }}
lastmod: {{ with os.Getenv "HUGO_CUSTOM_DATE" }}{{ . }}{{ else }}{{ .Date }}{{ end }}
image: 
math: 
draft: true
---
