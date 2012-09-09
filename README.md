# Kumo

## Overview

Manage workspaces in EC2

## Configuration File

    # ~/.kumorc
    ---
    :sets:
      :default:
        :access-key-id: 'xxxxx'
        :secret-access-key: 'xxxxx'
        :keypair: 'default'
        :region: 'us-east-1'
        :type-id: 't1.micro'
        :image-id: 'ami-a29943cb'   # Ubuntu 12.04
        :groups:
        - 'kumo'
        :tag: 'kumo'
    
      :scratch:
        :image-id: 'ami-a29943cb'   # Ubuntu 12.04
        :type-id: 'm1.small'
        :tag: 'scratch'
    
      :pair:
        :keypair: 'pairprogramming'
        :type-id: 'm1.small'
        :tag: 'pair'
    
      :micro:
        :type-id: 't1.micro'
      
      :small:
        :type-id: 'm1.small'
      
      :medium:
        :type-id: 'm1.medium'
      
      :large:
        :type-id: 'm1.large'


## Examples

    kumo list
    kumo launch
    kumo terminate
    kumo start
    kumo stop
    kumo dns

    kumo --config file.yaml COMMAND

    kumo launch
      --region us-east-1 --type-id t1.micro --image-id ami-a29943cb --keypair mykeypair
      -t scratch -g scratch
    
    kumo start -s scratch
    kumo start -s foo,scratch
    
    kumo stop
    kumo stop --region=us-east-1 --tag=kumo
    
    kumo start -s scratch
    kumo stop -s pair,micro

    kumo terminate
    kumo terminate --tag scratch
    
    kumo list
    kumo list --tag scratch
