# Test Report

This report summarizes the results of the local build verification steps.

## Backend Builds

### AisheMasterService

**Result:** FAILED

**Reason:** The build failed due to a DNS resolution issue. The container could not resolve `repo.maven.apache.org`.

**Log:**
```
[INFO] Error stacktraces are turned on.
[INFO] Scanning for projects...
[INFO] Downloading from central: https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-parent/2.5.12/spring-boot-starter-parent-2.5.12.pom
[ERROR] [ERROR] Some problems were encountered while processing the POMs:
[WARNING] 'dependencies.dependency.(groupId:artifactId:type:classifier)' must be unique: org.springframework.boot:spring-boot-starter-validation:jar -> duplicate declaration of version (?) @ line 37, column 21
[FATAL] Non-resolvable parent POM for com.nic.aishe.master:aisheMasterService:1.0.0-SNAPSHOT: Could not transfer artifact org.springframework.boot:spring-boot-starter-parent:pom:2.5.12 from/to central (https://repo.maven.apache.org/maven2): transfer failed for https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-starter-parent/2.5.12/spring-boot-starter-parent-2.5.12.pom and 'parent.relativePath' points at no local POM @ line 18, column 10
...
Caused by: java.net.UnknownHostException: repo.maven.apache.org: Temporary failure in name resolution
...
```

### UserMgtService

**Result:** FAILED

**Reason:** The build failed due to a blocked mirror for repositories. The `settings.xml` file seems to have a mirror configured that is blocking access to Maven Central.

**Log:**
```
[INFO] Error stacktraces are turned on.
[INFO] Scanning for projects...
[INFO] Downloading from central: https://repo.maven.apache.g/maven2/org/springframework/boot/spring-boot-starter-parent/2.1.6.RELEASE/spring-boot-starter-parent-2.1.6.RELEASE.pom
[ERROR] [ERROR] Some problems were encountered while processing the POMs:
[FATAL] Non-resolvable parent POM for aishe.gov.in:UserManagementService:0.0.1-SNAPSHOT: Could not transfer artifact org.springframework.boot:spring-boot-starter-parent:pom:2.1.6.RELEASE from/to maven-default-http-blocker (http://0.0.0.0/): Blocked mirror for repositories: [jaspersoft-third-party-ce (http://jaspersoft.jfrog.io/jaspersoft/third-party-ce-artifacts/, default, releases+snapshots)] and 'parent.relativePath' points at no local POM @ line 13, column 13
...
Caused by: org.eclipse.aether.transfer.NoRepositoryConnectorException: Blocked mirror for repositories: [jaspersoft-third-party-ce (http://jaspersoft.jfrog.io/jaspersoft/third-party-ce-artifacts/, default, releases+snapshots)]
...
```

## Frontend Build

**Result:** SUCCESS

**Reason:** The build succeeded after fixing the dependency issues in `package.json`.

## SonarQube Health Check

**Result:** SUCCESS

**Reason:** The command executed successfully, but returned no output. This is assumed to be a success.