"""
mips_test_lib setup.py
"""

from setuptools import setup

setup(
    name='mips_test_lib',
    version='0.0.1',
    author='Roi Amiel',
    author_email='roiamiel.ra@gmail.com',
    packages=['mips_test_lib'],
    license='MIT',
    description='MIPS cpu test lib for verilog.',
    install_requires=[
        'mipsy3==3.0.0',
    ],
)
