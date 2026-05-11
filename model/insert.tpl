func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) error {
{{- if .withCache}}
	{{.keys}}
{{- end}}
{{- if .withCache}}
	if err := m.Create(ctx, data); err != nil {
		return err
	}

	return m.cache.DelCtx(ctx, {{.keyValues}})
{{- else}}
	return m.Create(ctx, data)
{{- end}}
}
