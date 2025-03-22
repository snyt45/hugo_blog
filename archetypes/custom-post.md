---
title: "{{ replace .Name "-" " " | title }}"
description: 
slug: "{{ os.Getenv "HUGO_CUSTOM_SLUG" | default .Name }}"
date: {{ .Date }}
lastmod: {{ .Date }}
image: 
math: 
draft: true
---
