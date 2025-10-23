pipeline {
    agent none // We will specify the agent for each stage

    stages {
        stage('Build All') {
            parallel {

                stage('Build AisheMasterService') {
                    agent {
                        docker { image 'maven:3.8.6-jdk-11' }
                    }
                    steps {
                        dir('aishe_backend/AisheMasterService') {
                            sh 'mvn -DskipTests -e clean package'
                        }
                    }
                    post {
                        success {
                            archiveArtifacts artifacts: 'aishe_backend/AisheMasterService/target/*.jar', followSymlinks: false
                        }
                    }
                }

                stage('Build UserMgtService') {
                    agent {
                        docker { image 'maven:3.8.6-jdk-11' }
                    }
                    steps {
                        dir('aishe_backend/UserMgtService') {
                            sh 'mvn -DskipTests -e clean package'
                        }
                    }
                    post {
                        success {
                            archiveArtifacts artifacts: 'aishe_backend/UserMgtService/target/*.jar', followSymlinks: false
                        }
                    }
                }

                stage('Build Frontend') {
                    agent {
                        docker {
                            image 'node:18'
                            args  '--ulimit nofile=65536:65536'
                        }
                    }
                    steps {
                        dir('aishe_frontend') {
                            sh '''
                                # Create a container-local temp directory and copy project (excluding node_modules)
                                TMPDIR=$(mktemp -d)
                                tar -cf - --exclude=node_modules . | (cd "$TMPDIR" && tar -xf -)
                                cd "$TMPDIR"

                                # Raise file descriptor limit inside container
                                ulimit -n 65536
                                export NODE_OPTIONS="--max-old-space-size=4096"

                                # Use container-local npm cache
                                mkdir -p .npm
                                npm_config_cache=$PWD/.npm npm ci --legacy-peer-deps

                                # Build the Angular project
                                npm_config_cache=$PWD/.npm npm run build

                                # Copy the built artifacts back to the Jenkins workspace
                                mkdir -p "$WORKSPACE/aishe_frontend/dist"
                                cp -R dist/* "$WORKSPACE/aishe_frontend/dist/" || true
                            '''
                        }
                    }
                    post {
                        success {
                            archiveArtifacts artifacts: 'aishe_frontend/dist/**', followSymlinks: false
                        }
                    }
                }

            } // end parallel
        } // end stage
    } // end stages
} // end pipeline
