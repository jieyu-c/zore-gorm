func (m *default{{.upperStartCamelObject}}Model) FindOneBy{{.upperField}}(ctx context.Context, {{.in}}) (*{{.upperStartCamelObject}}, error) {
{{- if .withCache}}
	{{.cacheKey}}

	var resp {{.upperStartCamelObject}}
	var primaryKey any
	found := false

	err := m.cache.TakeWithExpireCtx(ctx, &primaryKey, {{.cacheKeyVariable}}, func(val any, expire time.Duration) error {
	{{- if .postgreSql}}
		row, er := m.Where(strings.NewReplacer(
			"$10", "?", "$9", "?", "$8", "?", "$7", "?", "$6", "?", "$5", "?", "$4", "?", "$3", "?", "$2", "?", "$1", "?",
		).Replace({{ printf "%q" .originalField }}), {{.lowerStartCamelField}}).First(ctx)
	{{- else}}
		row, er := m.Where("{{.originalField}}", {{.lowerStartCamelField}}).First(ctx)
	{{- end}}
		if er != nil {
			if errors.Is(er, gorm.ErrRecordNotFound) {
				return sql.ErrNoRows
			}
			return er
		}

		resp = row
		found = true
		primaryKey = row.{{.upperStartCamelPrimaryKey}}

		return m.cache.SetWithExpireCtx(ctx, m.formatPrimary(primaryKey), &resp, expire+5*time.Second)
	})

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) || errors.Is(err, gorm.ErrRecordNotFound) || m.cache.IsNotFound(err) {
			return nil, ErrNotFound
		}

		return nil, err
	}

	if found {
		return &resp, nil
	}

	err = m.cache.TakeCtx(ctx, &resp, m.formatPrimary(primaryKey), func(v any) error {
		return m.queryPrimary(ctx, v, primaryKey)
	})

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) || errors.Is(err, gorm.ErrRecordNotFound) || m.cache.IsNotFound(err) {
			return nil, ErrNotFound
		}

		return nil, err
	}

	return &resp, nil
{{- else}}
	{{- if .postgreSql}}
	row, err := m.Where(strings.NewReplacer(
		"$10", "?", "$9", "?", "$8", "?", "$7", "?", "$6", "?", "$5", "?", "$4", "?", "$3", "?", "$2", "?", "$1", "?",
	).Replace({{ printf "%q" .originalField }}), {{.lowerStartCamelField}}).First(ctx)
	{{- else}}
	row, err := m.Where("{{.originalField}}", {{.lowerStartCamelField}}).First(ctx)
	{{- end}}
	switch {
	case err == nil:
		return &row, nil
	case errors.Is(err, gorm.ErrRecordNotFound):
		return nil, ErrNotFound
	default:
		return nil, err
	}
{{- end}}
}
