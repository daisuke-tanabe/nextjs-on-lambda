<div align="left">
  <h1>nextjs-on-lambda</h1>
  <picture>
    <img src="https://github.com/user-attachments/assets/13989abd-3db7-4cb8-beee-7c1776032489" with="358" height="186" />
  </picture>
</div>

## 準備

### AWS CLI

AWS CLIをインストールして`~/.aws/config`に追加する。

```
[profile daisuke-tanabe]
sso_session=daisuke-tanabe
sso_account_id={SSO_ACCOUNT_ID}
sso_role_name=AdministratorAccess
region={REGION}

[sso-session daisuke-tanabe]
sso_start_url={SSO_START_URL}
sso_region={REGION}
sso_registration_scopes=sso:account:access
```

### terraform

```
// インフラの適用
terraform apply

// 途中で失敗したらECRにDockerイメージをプッシュする

// インフラ適用後にCloudfrontからLambdaを呼び出すため、LambdaにCloudfrontの権限を与える
// Cloudfrontからも確認可能
aws lambda --profile daisuke-tanabe add-permission \
--statement-id "AllowCloudFrontServicePrincipal" \
--action "lambda:InvokeFunctionUrl" \
--principal "cloudfront.amazonaws.com" \
--source-arn "arn:aws:cloudfront::{SSO_ACCOUNT_ID}:distribution/{DISTRIBUTION_ID}" \
--region "{REGION}" \
--function-name nextjs-on-lambda 
```

### ECR

ECRリポジトリを作成してイメージをプッシュする

```
// Dockerクライアントを認証する
aws ecr get-login-password --profile ${SSO_PROFILE} --region {REGION} | docker login --username AWS --password-stdin {SSO_ACCOUNT_ID}.dkr.ecr.{REGION}.amazonaws.com

// Dockerイメージを構築する
docker build -t daisuke-tanabe/nextjs-on-lambda .

// イメージにタグをつける
docker tag daisuke-tanabe/nextjs-on-lambda:latest {SSO_ACCOUNT_ID}.dkr.ecr.{REGION}.amazonaws.com/daisuke-tanabe/nextjs-on-lambda:latest

// AWSにイメージをプッシュする
docker push {REGION}.dkr.ecr.{REGION}.amazonaws.com/daisuke-tanabe/nextjs-on-lambda:latest
```