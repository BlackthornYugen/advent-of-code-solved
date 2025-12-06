package lib

import (
	"flag"
	"log/slog"
	"os"
)

func Setup() string {
	debug := flag.Bool("debug", false, "Enable debug logging")
	flag.Parse()

	opts := &slog.HandlerOptions{
		Level: slog.LevelInfo,
	}
	if *debug || os.Getenv("LOG_LEVEL") == "DEBUG" {
		opts.Level = slog.LevelDebug
	}
	logger := slog.New(slog.NewTextHandler(os.Stdout, opts))
	slog.SetDefault(logger)

	filename := "input.txt"
	if args := flag.Args(); len(args) > 0 {
		filename = args[0]
	}

	return filename
}
