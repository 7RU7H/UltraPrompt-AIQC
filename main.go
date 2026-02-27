package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

func main() {
	// 1. Define flags
	promptPath := flag.String("p", "", "Path to the base prompt file")
	userQuery := flag.String("q", "", "The query or instructions to add")
	filesToInclude := flag.String("f", "", "Comma-separated list of files to include")

	flag.Parse()

	// Validation
	if *promptPath == "" || *userQuery == "" {
		fmt.Println("Error: Both -p (prompt file) and -q (query) are required.")
		flag.Usage()
		os.Exit(1)
	}

	var builder strings.Builder

	// 2. Read and append the Prompt File
	promptContent, err := os.ReadFile(*promptPath)
	if err != nil {
		fmt.Printf("Error reading prompt file: %v\n", err)
		os.Exit(1)
	}
	builder.Write(promptContent)
	builder.WriteString("\n\n")

	// 3. Append User Query
	builder.WriteString("### USER QUERY ###\n")
	builder.WriteString(*userQuery)
	builder.WriteString("\n\n")

	// 4. Append included files
	if *filesToInclude != "" {
		files := strings.Split(*filesToInclude, ",")
		for _, filePath := range files {
			filePath = strings.TrimSpace(filePath)
			content, err := os.ReadFile(filePath)
			if err != nil {
				fmt.Printf("Warning: Could not read file %s: %v\n", filePath, err)
				continue
			}
			builder.WriteString(fmt.Sprintf("### FILE: %s ###\n", filePath))
			builder.Write(content)
			builder.WriteString("\n\n")
		}
	}

	// 5. Output to stdout
	fmt.Print(builder.String())
}
