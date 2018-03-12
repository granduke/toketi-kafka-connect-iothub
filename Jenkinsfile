#!groovy

def csh(String str) {
    ansiColor('xterm') {
      sh str
    }
}

def slack(String channel, String msg, String color='good') {
    slackSend color: color, channel: channel, message: msg
}

@NonCPS
def get_version(String md) {
    return (md =~ /iotHubKafkaConnectVersion = "(.*)"/)[0][1]
}

def is_env(String str) {
    return BRANCH_NAME == str
}

node('kubernetes') {
    if (!is_env('master') || !is_env('develop')) {
        deleteDir()
        checkout scm
        md = readFile 'build.sbt'
        version = get_version md
        image_name = "toketi-kafka-connect-iot:latest"
        build_name = "toketi-kafka-connect-iot:${artifact_version}"
        currentBuild.setDisplayName(build_name)

        if (!is_env('master')) {
            image_name += "-${BRANCH_NAME}"
        }

        slack 'geomesa-cd', "${build_name}: Job starting..."

        step([$class: 'GitHubSetCommitStatusBuilder'])

        slack 'geomesa-cd', "${build_name}: Starting build"
        withEnv(["IMAGE=nexus-docker.granduke.net/${image_name}"]) {
            stage ('Build') {
                slack 'geomesa-cd', "${build_name}: Building docker image..."
                csh 'make build-docker'
                slack 'geomesa-cd', "${build_name}: Docker build finished"
                csh 'make push-docker'
            }
        }
        slack 'geomesa-cd', "${build_name}: Build finished"
        slack 'geomesa-cd', "${build_name}: Starting release"
        stage ('Release') {
            context = is_env('master') ? 'azure-prod' : 'azure-dev'
            csh "kubectl config use-context ${context}"
            csh "kubectl get po -n vanessa | grep connect | cut -f1 -d\" \" | xargs -I X sh -c '{ kubectl delete po -n vanessa X; sleep 10; }'"
        }
        slack 'geomesa-cd', "${build_name}: Release finished"
        slack 'geomesa-cd', "${build_name}: Job finished"
    }
}
