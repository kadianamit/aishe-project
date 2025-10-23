# CI/CD Diagnostics and Troubleshooting

This document provides diagnostic commands and troubleshooting steps for common issues encountered in the Jenkins CI/CD pipeline.

## Network and DNS Diagnostics

Run these commands on the Jenkins host to diagnose network and DNS issues.

### DNS Resolution

This command checks if the Jenkins host can resolve `repo.maven.apache.org`.

```bash
nslookup repo.maven.apache.org
```

### Maven Central Connectivity

This command checks if the Jenkins host can connect to Maven Central.

```bash
curl -sS https://repo.maven.apache.org/maven2/
```

### SonarQube Connectivity

This command checks if the Jenkins host can connect to the SonarQube server. Replace `http://host.docker.internal:9001` with your SonarQube server URL if different.

```bash
curl -sS http://host.docker.internal:9001/api/server/version
```

## Docker Diagnostics

These commands are run from within a Docker container and help diagnose issues related to the container's network environment.

### DNS inside Docker

```bash
docker run --rm --dns 8.8.8.8 maven:3.8.6-jdk-11 sh -c "nslookup repo.maven.apache.org || true; cat /etc/resolv.conf"
```

### Maven Central Connectivity from Docker

```bash
docker run --rm --dns 8.8.8.8 curlimages/curl:8.4.0 -sS https://repo.maven.apache.org/maven2/ | sed -n '1,20p' || true
```

### SonarQube Connectivity from Docker

```bash
docker run --rm --dns 8.8.8.8 --add-host=host.docker.internal:host-gateway curlimages/curl:8.4.0 -sS http://host.docker.internal:9001/api/server/version || true
```

## Maven `settings.xml` Issues

If you encounter "Blocked mirror for repositories" errors, it's likely due to your `~/.m2/settings.xml` file.

- **HTTP Mirrors:** If your `settings.xml` contains HTTP mirrors (e.g., `http://jaspersoft.jfrog.io`), change them to HTTPS or remove the mirror entries.
- **Blocked Mirrors:** If your company uses a Maven repository manager, ensure it's configured correctly and not blocking access to public repositories.

## Corporate Proxy Issues

If you are behind a corporate proxy, you need to configure the proxy settings in Jenkins.

1.  Go to **Manage Jenkins** -> **Manage Jenkins** -> **Configure System**.
2.  Under **Global properties**, add the following environment variables:
    - `HTTP_PROXY`: Your proxy URL (e.g., `http://proxy.example.com:8080`)
    - `HTTPS_PROXY`: Your proxy URL (e.g., `http://proxy.example.com:8080`)
    - `NO_PROXY`: A comma-separated list of hosts to bypass the proxy (e.g., `localhost,127.0.0.1,host.docker.internal`)

The `Jenkinsfile` is configured to use these environment variables and pass them to the Docker containers.

## SonarQube Credentials

The pipeline uses a SonarQube token with the ID `sonarqube-token1`. To add this credential in Jenkins:

1.  Go to **Manage Jenkins** -> **Credentials**.
2.  Click on **(global)**.
3.  Click **Add Credentials**.
4.  Set the following values:
    - **Kind**: `Secret text`
    - **Secret**: Your SonarQube token
    - **ID**: `sonarqube-token1`
    - **Description**: SonarQube authentication token