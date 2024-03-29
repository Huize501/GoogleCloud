from setuptools import find_packages
from setuptools import setup

REQUIRED_PACKAGES = ['cloudml-hypertune', 'google-cloud-bigquery==1.17.0','pandas-gbq==0.11.0']

setup(
    name='trainer',
    version='0.1',
    install_requires=REQUIRED_PACKAGES,
    packages=find_packages(),
    include_package_data=True,
    description='My training application package'
    )