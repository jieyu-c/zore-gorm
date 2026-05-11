# zore-gorm model templates

Goctl model templates that generate code using **GORM Generics** (`gorm.G[T](db, gorm.WithResult())` embedded as `gorm.Interface[T]`) instead of `sqlx` / `sqlc` raw SQL.

## Requirements

- **`gorm.io/gorm` ≥ v1.30** (Generics API).
- Pass `*gorm.DB` into `New*Model` instead of `sqlx.SqlConn`.

## Constructor

- **Without cache:** `NewFooModel(db *gorm.DB) FooModel`
- **With cache:** `NewFooModel(db *gorm.DB, c cache.CacheConf, opts ...cache.Option) FooModel`

## API changes vs default goctl

- **`Insert(ctx, data)`** returns **`error`** only (no `sql.Result`); auto-increment IDs are written back on `data` by GORM.
- Use **`withDB(tx *gorm.DB)`** on the custom model for the same semantics as the old `withSession` helper (lowercase method on the generated interface, same as upstream goctl behavior).
- Entity structs use **`gorm:"column:..."`** tags; **`TableName()`** is generated on the entity type.

## Cache

With `--cache`, behaviour follows go-zero `sqlc` index/primary cache rules: `TakeCtx` / `TakeWithExpireCtx` / `DelCtx` on `github.com/zeromicro/go-zero/core/stores/cache`.

## Usage

Point goctl at this directory’s `model` folder as your **`-home` / template home** when generating models (see goctl documentation for your version).
