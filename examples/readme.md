# Organisation-wise Secrets

Some secrets are best managed at the organization level for security and reuse across multiple repositories. The following table shows which secrets are needed at the organization level for each pipeline:

| Pipeline                       | Organisation Secret Name   | Purpose                                 |
|---------------------------------|---------------------------|-----------------------------------------|
| Publish Policy                  | `POLICY_FTP_PASS`         | FTP password for publishing policies    |
| Google Play Publish Workflow    | `GOOGLE_PLAY_JSON`        | Google Play API service account JSON    |

## How to Create Organisation Secrets

1. Go to your organization's **Settings**.
2. Navigate to **Secrets and variables > Actions**.
3. Click **New organization secret**.
4. Enter the secret name (e.g., `POLICY_FTP_PASS` or `GOOGLE_PLAY_JSON`) and value.
5. Select which repositories can access the secret.

## Obtaining and Formatting the Google Play JSON

To use the Google Play Publish Workflow, you need a Google Play API service account JSON file. This file allows GitHub Actions to authenticate and interact with the Google Play Developer API.

### Steps to Obtain the JSON

1. Go to the [Google Play Console](https://play.google.com/console).
2. Navigate to **Setup > API access**.
3. Click **Create new service account** in the Google Cloud Console.
4. Assign the necessary permissions (typically "Release to production, exclude devices, and use Play Console API").
5. Create and download the service account JSON key file.

### How the JSON Should Look

The JSON file should resemble the following structure:

```json
{
    "type": "service_account",
    "project_id": "your-project-id",
    "private_key_id": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
    "client_email": "your-service-account@your-project-id.iam.gserviceaccount.com",
    "client_id": "123456789012345678901",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account%40your-project-id.iam.gserviceaccount.com"
}
```

> **Note:** Store the entire JSON content as the value for the `GOOGLE_PLAY_JSON` secret. Keep this file secure and do not share it publicly.



# Publish Policy Setup Guide

This guide explains how to use the `Publish Policy` GitHub Actions workflow.

## Prerequisites

- Ensure you have access to the repository.



## Example Workflow YAML

```yaml
name: Publish Policy
on:
    release:
        types: [published]
jobs:
    ftp-upload:
        uses: Majszlinger/Pipelines/.github/workflows/policy-publish.yml@main
        # with:
        #   local-dir: ./policy/
        secrets:
            POLICY_FTP_PASS: ${{ secrets.POLICY_FTP_PASS }}
```

## Steps

1. **Add the workflow YAML**  
     Copy the example above into `examples/publish-policy.yml` in your repository.

2. **Configure Secrets**  
     Ensure your repository has access to the organization secret `POLICY_FTP_PASS`.

3. **Customize Local Directory (Optional)**  
     Uncomment and set the `local-dir` parameter under `with:` if you want to specify a different directory to upload.

4. **Trigger the Workflow**  
     The workflow runs automatically when a release is published.

## Reference

- [Majszlinger/Pipelines](https://github.com/Majszlinger/Pipelines)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Google Play Publish Workflow Guide

This section explains how to use the `Publish to Google Play (Remote)` GitHub Actions workflow.

### Prerequisites

- Access to the repository.
- Store the following secrets in your repository:
    - `GOOGLE_KEYSTORE_BASE64`: Base64-encoded keystore file.
    - `GOOGLE_KEY_PROPERTIES_BASE64`: Base64-encoded key properties file.

### Organisation-wise Secrets

- Ensure your repository has access to the organization secret `GOOGLE_PLAY_JSON`.

### Example Workflow YAML

```yaml
name: Publish to Google Play (Remote)
on:
    release:
        types: [published]
jobs:
    publish:
        uses: Majszlinger/Pipelines/.github/workflows/frontend/google-play-publish.yml@main
        with:
            flutter-version: '3.29.3'
            package-name: 'com.example.app'
        secrets:
            GOOGLE_KEYSTORE_BASE64: ${{ secrets.GOOGLE_KEYSTORE_BASE64 }}
            GOOGLE_KEY_PROPERTIES_BASE64: ${{ secrets.GOOGLE_KEY_PROPERTIES_BASE64 }}
            GOOGLE_PLAY_JSON: ${{ secrets.GOOGLE_PLAY_JSON }}
```

### Steps

1. **Add the workflow YAML**  
     Copy the example above into `examples/google-play-publish.yml` in your repository.

2. **Configure Secrets**  
     Add the required repository secrets: `GOOGLE_KEYSTORE_BASE64`, `GOOGLE_KEY_PROPERTIES_BASE64`.  
     Ensure your repository has access to the organization secret `GOOGLE_PLAY_JSON`.

3. **Customize Parameters (Optional)**  
     Adjust `flutter-version` and `package-name` under `with:` as needed for your project.

4. **Trigger the Workflow**  
     The workflow runs automatically when a release is published.

### Reference

- [Majszlinger/Pipelines](https://github.com/Majszlinger/Pipelines)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)