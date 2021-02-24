/* (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

#ifndef SOFTMATTING_H
#define SOFTMATTING_H

//Local libraries

///
/// \brief The SoftMatting class provides an API to retrieve a smoothed transmission previously generated based on the input image
/// this is achieved by appliying a soft matting process
///
class SoftMatting
{
public:
    ///
    /// \brief SoftMatting constructor
    ///
    SoftMatting();
    ///
    /// \brief ~SoftMatting destructor
    ///
    virtual ~SoftMatting();

    ///
    /// \brief softMattingTransmission applies a soft matting process to a previosuly generated transmission map based in an input provided
    /// \param input a @ref float * const that holds all the image's normalized data must be wrapped packaged in RGBRGBRGB or RGBARGBARGBA fashion
    /// \param transmissionMap a @ref float * that holds the current transmision map that will be modified by using a soft matting process
    /// \param channels a int that defines the number of channels in the input image 3 for RGB etc 4 if alpha should be taking in cosideration RGBA
    /// \param width a int that represents the width of the input image
    /// \param height a int that represents the height of the input image
    /// \param softMattingWindowSize a int that defines the window size that will be used in the soft matting process
    ///
    void softMattingTransmission(float * const input,
                                 float * transmissionMap,
                                 const int channels,
                                 const int width,
                                 const int height,
                                 const int softMattingWindowSize);
private:
    SoftMatting(const SoftMatting &softMatting) = delete;
    const SoftMatting& operator = (const SoftMatting &softMatting) = delete;
    class SoftMattingPrivate;
    SoftMattingPrivate *mPimpl;
};

#endif // SOFTMATTING_H
