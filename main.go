package main

import (
	"html/template"
	"io/fs"
	"log"
	"net/http"
	"strings"

	"github.com/aerogo/aero"
	"github.com/pkg/errors"
)

func main() {
	app := aero.New()

	app.Get("/", func(ctx aero.Context) error {
		return ServeTemplate(nil, ctx, "index.html", "tree.html")
	})

	app.Get("/matrix", func(ctx aero.Context) error {
		return ServeTemplate(nil, ctx, "matrix.html")
	})

	// fileserver
	app.Get("/*file", func(ctx aero.Context) error {
		name := ctx.Get("file")
		if name[len(name)-1] == '/' {
			return ctx.Error(http.StatusForbidden)
		}
		return ctx.File("static/" + ctx.Get("file"))
	})

	// log requests
	app.Use(func(handler aero.Handler) aero.Handler {
		return func(ctx aero.Context) error {
			log.Printf(
				"%s: %s %s",
				ctx.Request().Internal().RemoteAddr,
				ctx.Request().Method(),
				ctx.Request().Internal().URL,
			)
			return handler(ctx)
		}
	})

	log.Print("Startup")
	app.Config.Ports.HTTP = 8000
	app.Run()
}

func OnError(err error, ctx aero.Context) error {
	ctx.Redirect(http.StatusInternalServerError, "/err.html")
	log.Print("ERROR: ", err)
	return err
}

func ServeTemplate(data any, ctx aero.Context, names ...string) error {
	t, err := template.New("").Funcs(template.FuncMap{
		"arr": func(arr ...any) []any {
			return arr
		},
		"IsVideo": IsVideo,
	}).ParseFiles(names...)
	if err != nil {
		OnError(errors.Wrap(err, "template parse"), ctx)
		return err
	}

	if err := t.ExecuteTemplate(ctx.Response().Internal(), names[0], data); err != nil {
		OnError(errors.Wrap(err, "template execute"), ctx)
		return err
	}

	return nil
}

func IsVideo(item fs.DirEntry) bool {
	return strings.HasSuffix(item.Name(), ".mp4")
}
