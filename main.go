package main

import (
	"html/template"
	"log"
	"net/http"

	"github.com/aerogo/aero"
	"github.com/pkg/errors"
)

func main() {
	app := aero.New()

	app.Get("/", func(ctx aero.Context) error {
		if err := ServeTemplate("index.html", nil, ctx); err != nil {
			return err
		}

		return nil
	})

	// fileserver
	app.Get("/*file", func(ctx aero.Context) error {
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

func ServeTemplate(name string, data any, ctx aero.Context) error {
	t, err := template.New("").Funcs(template.FuncMap{
		"arr": func(arr ...any) []any {
			return arr
		},
	}).ParseFiles(name)
	if err != nil {
		OnError(errors.Wrap(err, "template parse"), ctx)
		return err
	}

	if err := t.ExecuteTemplate(ctx.Response().Internal(), name, data); err != nil {
		OnError(errors.Wrap(err, "template execute"), ctx)
		return err
	}

	return nil
}
