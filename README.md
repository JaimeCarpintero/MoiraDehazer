# MoiraDehazer

##Dark Channel Prior Dehazing implementation for IOS using Swift 5

I started this solution as a personal project to apply the acquired knowledge gathered from Swift programming courses.
This project is based on a more complex solution made in C++ which is my language of choice.

The project is very simple, it consists of an image picker and an image view, the idea is to select a hazy mage from the  galery, then apply a dehazing algorithm based on the Dark Channel Prior described in the paper "Single Image Haze Removal Using Dark Channel Prior"[1] by "Kaiming He, Jian Sun and Xiaoou Tang". There are many papers that can be found on the internet that could serve as guidance aside the one mentioned if more in-depth detail is required.

<p align="center">
<img src="RepositoryImages/01.png" width="200" /><img src="RepositoryImages/02.png" width="200" /><img src="RepositoryImages/03.png" width="200" />
</p>

This solution was made in Xcode 12 for IOS 14.4 and was primarily written in Swift 5.
Soft matting library libSoftMatting.dylib is a shared library that I developed to apply a soft matting process to a  previously generated transmission map, the library was developed in C++, library and header/bridge(s) are provided, although the library provided is for simulator use only. Feel free to ask for a device version. 

##References
[1]. He, K., Sun, J., & Tang, X. (2010). Single image haze removal using dark channel prior. IEEE transactions on pattern analysis and machine intelligence, 33(12), 2341-2353.

