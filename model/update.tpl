func (m *default{{.upperStartCamelObject}}Model) Update(ctx context.Context, {{if .containsIndexCache}}newData{{else}}data{{end}} *{{.upperStartCamelObject}}) error {
{{- if .withCache}}
	{{- if .containsIndexCache}}
	data, err := m.FindOne(ctx, newData.{{.upperStartCamelPrimaryKey}})
	if err != nil {
		return err
	}

	{{end}}
	{{.keys}}
{{- end}}
	rec := {{if .containsIndexCache}}newData{{else}}data{{end}}
{{- if and .withCache .containsIndexCache}}
	_, err = m.Where("{{.originalPrimaryKey}} = ?", rec.{{.upperStartCamelPrimaryKey}}).Updates(ctx, *rec)
{{- else}}
	_, err := m.Where("{{.originalPrimaryKey}} = ?", rec.{{.upperStartCamelPrimaryKey}}).Updates(ctx, *rec)
{{- end}}
	if err != nil {
		return err
	}
{{- if .withCache}}

	return m.cache.DelCtx(ctx, {{.keyValues}})
{{- else}}

	return nil
{{- end}}
}
