#!/usr/bin/env python3
#
# Notarize a file (e.g. a .dmg)
#
# Usage: notarize-macos.py <Apple ID username> <Apple ID password> <bundle ID> <file>
#
# See https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution#3087727
# for information on how to prepare your app for notarization.
#
# Adapted from https://gist.github.com/estan/505cd5b4c18d80f1dd17ac2ea0f6c69e

from argparse import ArgumentParser
from subprocess import check_output
from plistlib import loads
from time import sleep

def main():
    parser = ArgumentParser()
    parser.add_argument('username', help='Apple ID user')
    parser.add_argument('password', help='Apple ID password')
    parser.add_argument('bundle', help='Primary bundle ID, for example com.mypackage')
    parser.add_argument('path', help='File to be notarized (e.g. .dmg)')
    args = parser.parse_args()

    print('requesting notarization of {}...'.format(args.path))

    request_uuid = loads(check_output([
        'xcrun',
        'altool',
        '--notarize-app',
        '--primary-bundle-id', args.bundle,
        '--username', args.username,
        '--password', args.password,
        '--file', args.path,
        '--output-format', 'xml'
    ]))['notarization-upload']['RequestUUID']

    for i in range(200):
        response = loads(check_output([
            'xcrun',
            'altool',
            '--notarization-info', request_uuid,
            '--username', args.username,
            '--password', args.password,
            '--output-format', 'xml'
        ]))
        if response['notarization-info']['Status'] == 'success':
            print('notarization succeeded, see {}'.format(response['notarization-info']['LogFileURL']))
            print('stapling notarization to {}'.format(args.path))
            print(check_output(['xcrun', 'stapler', 'staple', args.path]).decode('utf-8'))
            return
        if response['notarization-info']['Status'] == 'invalid':
            raise RuntimeError('notarization failed, response was\n{}'.format(response))
        sleep(3)

    raise RuntimeError('notarization timed out, last response was\n{}'.format(response))


if __name__ == '__main__':
    main()
