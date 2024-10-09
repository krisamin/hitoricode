# HitoriCode

## Development

### Git

HitoriCode는 원활한 작업을 위하여 [`commitizen`](https://github.com/commitizen/cz-cli)을 사용합니다. 해당 환경은 아래와 같은 명령어로 설정할 수 있습니다.

```bash
bun install
```

해당 명령어의 실행을 위해서는 [`bun`](https://bun.sh/) 런타임이 설치되어있어야 합니다.

해당 프로젝트에서 Git Commit은 아래와 같은 순서로 진행할 수 있습니다.

```bash
git add . # Staging files
bun commit # Commit with commitizen (also work with 'bun cz')
```


