# Summit Malaga, November 2017.

## Caveat
THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

You can use this Software unless Apache Licence 2.0 : https://www.apache.org/licenses/LICENSE-2.0


## Purpose
This are the Slides for my FIWARE Summit Presentation, and a little shell script which might help to understand how an image or snapshot downloaded from Fiware Lab can be converted can transformed to an Image which can be instantiated in othe Virtualization solutions, including KVM or Virtual BOX.


## Script remove_cloudinit.sh
When using the script invoked from the command line, can take an argument: The image name to be modified. This image name can also be set this way:

    export image=......

The Script will mount the image, it will remove cloud init and it will change the password of the main user of the image. The main user of the image, as it is thought to work using FIWARE Lab images by default, is supposed to be centos, ubuntu or debian. It tryied to find the default user and sets it password to "passw0rd".

Additionally, another 2 variables can be exported:

* nomodeset - If this variable is defined (I mean defined, with no particular value), the script will try to modify grub.cfg file and set "nomodeset" to the kernel parameters.

.

    export nomodeset=yes


* outputformat - I this variable is defined, the script will try to convert the image to the output format given in the variable. Some possible values for outputformat are vdi, vmdk, raw -- Basically anything that "qemu-img convert" supports. Some examples:

.

    export outputformat=vdi
    export outputformat=vmdk
    export outputformat=raw


## Dockerfile
Any Dockerfile is a good way to explain what to install and what is it needed to run something. If you want so, you can create  your own Docker image:

    docker build -t remove_cloudinit  .

And you can use this way (a few examples):

    docker run --privileged -v /mylocaldirectory:/data -ti --name change -e image=yourimagefile.qcow2 -e nomodeset=yes -e outputformat=vdi remove_cloudinit
    docker run --privileged -v /mylocaldirectory:/data -ti --name change -e image=yourimagefile.qcow2 -e outputformat=vdi remove_cloudinit
    docker run --privileged -v /mylocaldirectory:/data -ti --name change -e image=yourimagefile.qcow2 -e nomodeset=yes remove_cloudinit
    docker run --privileged -v /mylocaldirectory:/data -ti --name change -e image=yourimagefile.qcow2 remove_cloudinit


* First of all, you must run this docker with *--privileged* option because it is going to mount images and this can only be done by root.
* In /data you can mount the directory where your image is stored. In case your provide "-e outputformat=xxx", a new image wil be created in the same directory/place as the qcow2 image file.

