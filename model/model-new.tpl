func new{{.upperStartCamelObject}}Model(db *gorm.DB{{if .withCache}}, c cache.CacheConf, opts ...cache.Option{{end}}) *default{{.upperStartCamelObject}}Model {
{{- if .withCache}}
	return &default{{.upperStartCamelObject}}Model{
		Interface: gorm.G[{{.upperStartCamelObject}}](db, gorm.WithResult()),
		cache:     cache.New(c, barrier{{.upperStartCamelObject}}, stat{{.upperStartCamelObject}}, sql.ErrNoRows, opts...),
	}
{{- else}}
	return &default{{.upperStartCamelObject}}Model{
		Interface: gorm.G[{{.upperStartCamelObject}}](db, gorm.WithResult()),
	}
{{- end}}
}

func new{{.upperStartCamelObject}}ModelTx(db *gorm.DB{{if .withCache}}, cli cache.Cache{{end}}) *default{{.upperStartCamelObject}}Model {
{{- if .withCache}}
	return &default{{.upperStartCamelObject}}Model{
		Interface: gorm.G[{{.upperStartCamelObject}}](db, gorm.WithResult()),
		cache:     cli,
	}
{{- else}}
	return &default{{.upperStartCamelObject}}Model{
		Interface: gorm.G[{{.upperStartCamelObject}}](db, gorm.WithResult()),
	}
{{- end}}
}
