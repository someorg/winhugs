--------------------------------------------------------------------------------
-- |
-- Module      :  Graphics.Rendering.OpenGL.GL.PixelRectangles.Convolution
-- Copyright   :  (c) Sven Panne 2002-2005
-- License     :  BSD-style (see the file libraries/OpenGL/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  provisional
-- Portability :  portable
--
-- This module corresponds to a part of section 3.6.1 (Pixel Storage Modes) of
-- the OpenGL 1.5 specs.
--
--------------------------------------------------------------------------------

module Graphics.Rendering.OpenGL.GL.PixelRectangles.Convolution (
   ConvolutionTarget(..), convolution,
   convolutionFilter1D, getConvolutionFilter1D,
   convolutionFilter2D, getConvolutionFilter2D,
   separableFilter2D, getSeparableFilter2D,
   copyConvolutionFilter1D, copyConvolutionFilter2D,
   convolutionWidth, convolutionHeight,
   maxConvolutionWidth, maxConvolutionHeight,
   ConvolutionBorderMode(..), convolutionBorderMode,
   convolutionFilterScale, convolutionFilterBias,
) where

import Foreign.Marshal.Alloc ( alloca )
import Foreign.Marshal.Utils ( with )
import Foreign.Ptr ( Ptr, nullPtr )
import Foreign.Storable ( Storable(..) )
import Graphics.Rendering.OpenGL.GL.Capability (
   EnableCap(CapConvolution1D, CapConvolution2D,CapSeparable2D),
   makeCapability )
import Graphics.Rendering.OpenGL.GL.BasicTypes (
   GLenum, GLint, GLsizei, GLfloat, Capability )
import Graphics.Rendering.OpenGL.GL.CoordTrans ( Position(..), Size(..) )
import Graphics.Rendering.OpenGL.GL.Extensions (
   FunPtr, unsafePerformIO, Invoker, getProcAddress )
import Graphics.Rendering.OpenGL.GL.PeekPoke ( peek1 )
import Graphics.Rendering.OpenGL.GL.PixelRectangles.ColorTable (
   PixelInternalFormat )
import Graphics.Rendering.OpenGL.GL.PixelRectangles.Rasterization (
    PixelData(..) )
import Graphics.Rendering.OpenGL.GL.PixelData ( withPixelData )
import Graphics.Rendering.OpenGL.GL.Texturing.PixelInternalFormat (
   marshalPixelInternalFormat' )
import Graphics.Rendering.OpenGL.GL.StateVar (
   GettableStateVar, makeGettableStateVar, StateVar, makeStateVar )
import Graphics.Rendering.OpenGL.GL.VertexSpec ( Color4(..) )
import Graphics.Rendering.OpenGL.GLU.ErrorsInternal (
   recordInvalidValue )

--------------------------------------------------------------------------------

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         




                                                                                                                                                                          












--------------------------------------------------------------------------------

data ConvolutionTarget =
     Convolution1D
   | Convolution2D
   | Separable2D
   deriving ( Eq, Ord, Show )

marshalConvolutionTarget :: ConvolutionTarget -> GLenum
marshalConvolutionTarget x = case x of
   Convolution1D -> 0x8010
   Convolution2D -> 0x8011
   Separable2D -> 0x8012

convolutionTargetToEnableCap :: ConvolutionTarget -> EnableCap
convolutionTargetToEnableCap x = case x of
   Convolution1D -> CapConvolution1D
   Convolution2D -> CapConvolution2D
   Separable2D -> CapSeparable2D

--------------------------------------------------------------------------------

convolution :: ConvolutionTarget -> StateVar Capability
convolution = makeCapability . convolutionTargetToEnableCap

--------------------------------------------------------------------------------

convolutionFilter1D :: PixelInternalFormat -> GLsizei -> PixelData a -> IO ()
convolutionFilter1D int w pd =
   withPixelData pd $
      glConvolutionFilter1D
         (marshalConvolutionTarget Convolution1D)
         (marshalPixelInternalFormat' int) w

foreign import stdcall unsafe "dynamic" dyn_glConvolutionFilter1D :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLsizei -> GLenum -> GLenum -> Ptr a -> IO ()) ; glConvolutionFilter1D :: (GLenum -> GLenum -> GLsizei -> GLenum -> GLenum -> Ptr a -> IO ()) ; glConvolutionFilter1D = dyn_glConvolutionFilter1D ptr_glConvolutionFilter1D ; ptr_glConvolutionFilter1D :: FunPtr a ; ptr_glConvolutionFilter1D = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glConvolutionFilter1D")) ; {-# NOINLINE ptr_glConvolutionFilter1D #-}

--------------------------------------------------------------------------------

getConvolutionFilter1D :: PixelData a -> IO ()
getConvolutionFilter1D = getConvolutionFilter Convolution1D

getConvolutionFilter :: ConvolutionTarget -> PixelData a -> IO ()
getConvolutionFilter t pd =
   withPixelData pd $ glGetConvolutionFilter (marshalConvolutionTarget t)

foreign import stdcall unsafe "dynamic" dyn_glGetConvolutionFilter :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLenum -> Ptr a -> IO ()) ; glGetConvolutionFilter :: (GLenum -> GLenum -> GLenum -> Ptr a -> IO ()) ; glGetConvolutionFilter = dyn_glGetConvolutionFilter ptr_glGetConvolutionFilter ; ptr_glGetConvolutionFilter :: FunPtr a ; ptr_glGetConvolutionFilter = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glGetConvolutionFilter")) ; {-# NOINLINE ptr_glGetConvolutionFilter #-}

--------------------------------------------------------------------------------

convolutionFilter2D :: PixelInternalFormat -> Size -> PixelData a -> IO ()
convolutionFilter2D int (Size w h) pd =
   withPixelData pd $
      glConvolutionFilter2D
         (marshalConvolutionTarget Convolution2D)
         (marshalPixelInternalFormat' int) w h

foreign import stdcall unsafe "dynamic" dyn_glConvolutionFilter2D :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLsizei -> GLsizei -> GLenum -> GLenum -> Ptr a -> IO ()) ; glConvolutionFilter2D :: (GLenum -> GLenum -> GLsizei -> GLsizei -> GLenum -> GLenum -> Ptr a -> IO ()) ; glConvolutionFilter2D = dyn_glConvolutionFilter2D ptr_glConvolutionFilter2D ; ptr_glConvolutionFilter2D :: FunPtr a ; ptr_glConvolutionFilter2D = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glConvolutionFilter2D")) ; {-# NOINLINE ptr_glConvolutionFilter2D #-}

--------------------------------------------------------------------------------

getConvolutionFilter2D :: PixelData a -> IO ()
getConvolutionFilter2D = getConvolutionFilter Convolution2D

--------------------------------------------------------------------------------

separableFilter2D ::
   PixelInternalFormat -> Size -> PixelData a -> PixelData a -> IO ()
separableFilter2D int (Size w h) pdRow pdCol =
   withPixelData pdRow $ \f1 d1 p1 ->
      withPixelData pdCol $ \f2 d2 p2 ->
         if f1 == f2 && d1 == d2
            then glSeparableFilter2D
                    (marshalConvolutionTarget Separable2D)
                    (marshalPixelInternalFormat' int) w h f1 d1 p1 p2
            else recordInvalidValue

foreign import stdcall unsafe "dynamic" dyn_glSeparableFilter2D :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLsizei -> GLsizei -> GLenum -> GLenum -> Ptr a -> Ptr a -> IO ()) ; glSeparableFilter2D :: (GLenum -> GLenum -> GLsizei -> GLsizei -> GLenum -> GLenum -> Ptr a -> Ptr a -> IO ()) ; glSeparableFilter2D = dyn_glSeparableFilter2D ptr_glSeparableFilter2D ; ptr_glSeparableFilter2D :: FunPtr a ; ptr_glSeparableFilter2D = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glSeparableFilter2D")) ; {-# NOINLINE ptr_glSeparableFilter2D #-}

--------------------------------------------------------------------------------

getSeparableFilter2D :: PixelData a -> PixelData a -> IO ()
getSeparableFilter2D pdRow pdCol =
   withPixelData pdRow $ \f1 d1 p1 ->
      withPixelData pdCol $ \f2 d2 p2 ->
         if f1 == f2 && d1 == d2
            then glGetSeparableFilter
                    (marshalConvolutionTarget Separable2D) f1 d1 p1 p2 nullPtr
            else recordInvalidValue

foreign import stdcall unsafe "dynamic" dyn_glGetSeparableFilter :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLenum -> Ptr a -> Ptr a -> Ptr a -> IO ()) ; glGetSeparableFilter :: (GLenum -> GLenum -> GLenum -> Ptr a -> Ptr a -> Ptr a -> IO ()) ; glGetSeparableFilter = dyn_glGetSeparableFilter ptr_glGetSeparableFilter ; ptr_glGetSeparableFilter :: FunPtr a ; ptr_glGetSeparableFilter = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glGetSeparableFilter")) ; {-# NOINLINE ptr_glGetSeparableFilter #-}

--------------------------------------------------------------------------------

copyConvolutionFilter1D :: PixelInternalFormat -> Position -> GLsizei -> IO ()
copyConvolutionFilter1D int (Position x y) =
   glCopyConvolutionFilter1D
      (marshalConvolutionTarget Convolution1D) (marshalPixelInternalFormat' int)
      x y

foreign import stdcall unsafe "dynamic" dyn_glCopyConvolutionFilter1D :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLint -> GLint -> GLsizei -> IO ()) ; glCopyConvolutionFilter1D :: (GLenum -> GLenum -> GLint -> GLint -> GLsizei -> IO ()) ; glCopyConvolutionFilter1D = dyn_glCopyConvolutionFilter1D ptr_glCopyConvolutionFilter1D ; ptr_glCopyConvolutionFilter1D :: FunPtr a ; ptr_glCopyConvolutionFilter1D = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glCopyConvolutionFilter1D")) ; {-# NOINLINE ptr_glCopyConvolutionFilter1D #-}

--------------------------------------------------------------------------------

copyConvolutionFilter2D :: PixelInternalFormat -> Position -> Size -> IO ()
copyConvolutionFilter2D int (Position x y) (Size w h) =
   glCopyConvolutionFilter2D
      (marshalConvolutionTarget Convolution2D) (marshalPixelInternalFormat' int)
      x y w h

foreign import stdcall unsafe "dynamic" dyn_glCopyConvolutionFilter2D :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLint -> GLint -> GLsizei -> GLsizei -> IO ()) ; glCopyConvolutionFilter2D :: (GLenum -> GLenum -> GLint -> GLint -> GLsizei -> GLsizei -> IO ()) ; glCopyConvolutionFilter2D = dyn_glCopyConvolutionFilter2D ptr_glCopyConvolutionFilter2D ; ptr_glCopyConvolutionFilter2D :: FunPtr a ; ptr_glCopyConvolutionFilter2D = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glCopyConvolutionFilter2D")) ; {-# NOINLINE ptr_glCopyConvolutionFilter2D #-}

--------------------------------------------------------------------------------

data ConvolutionParameter =
     ConvolutionBorderColor
   | ConvolutionBorderMode
   | ConvolutionFilterScale
   | ConvolutionFilterBias
   | ConvolutionFormat
   | ConvolutionWidth
   | ConvolutionHeight
   | MaxConvolutionWidth
   | MaxConvolutionHeight
   deriving ( Eq, Ord, Show )

marshalConvolutionParameter :: ConvolutionParameter -> GLenum
marshalConvolutionParameter x = case x of
   ConvolutionBorderColor -> 0x8154
   ConvolutionBorderMode -> 0x8013
   ConvolutionFilterScale -> 0x8014
   ConvolutionFilterBias -> 0x8015
   ConvolutionFormat -> 0x8017
   ConvolutionWidth -> 0x8018
   ConvolutionHeight -> 0x8019
   MaxConvolutionWidth -> 0x801a
   MaxConvolutionHeight -> 0x801b

--------------------------------------------------------------------------------

convolutionWidth :: ConvolutionTarget -> GettableStateVar GLsizei
convolutionWidth t = convolutionParameteri t ConvolutionWidth

convolutionHeight :: ConvolutionTarget -> GettableStateVar GLsizei
convolutionHeight t = convolutionParameteri t ConvolutionHeight

maxConvolutionWidth :: ConvolutionTarget -> GettableStateVar GLsizei
maxConvolutionWidth t = convolutionParameteri t MaxConvolutionWidth

maxConvolutionHeight :: ConvolutionTarget -> GettableStateVar GLsizei
maxConvolutionHeight t = convolutionParameteri t MaxConvolutionHeight

convolutionParameteri ::
   ConvolutionTarget -> ConvolutionParameter -> GettableStateVar GLsizei
convolutionParameteri t p =
   makeGettableStateVar (getConvolutionParameteri fromIntegral t p)

getConvolutionParameteri ::
   (GLint -> a) -> ConvolutionTarget -> ConvolutionParameter -> IO a
getConvolutionParameteri f t p =
   alloca $ \buf -> do
      glGetConvolutionParameteriv
         (marshalConvolutionTarget t) (marshalConvolutionParameter p) buf
      peek1 f buf

foreign import stdcall unsafe "dynamic" dyn_glGetConvolutionParameteriv :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> Ptr GLint -> IO ()) ; glGetConvolutionParameteriv :: (GLenum -> GLenum -> Ptr GLint -> IO ()) ; glGetConvolutionParameteriv = dyn_glGetConvolutionParameteriv ptr_glGetConvolutionParameteriv ; ptr_glGetConvolutionParameteriv :: FunPtr a ; ptr_glGetConvolutionParameteriv = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glGetConvolutionParameteriv")) ; {-# NOINLINE ptr_glGetConvolutionParameteriv #-}

--------------------------------------------------------------------------------

data ConvolutionBorderMode' =
     Reduce'
   | ConstantBorder'
   | ReplicateBorder'

marshalConvolutionBorderMode' :: ConvolutionBorderMode' -> GLint
marshalConvolutionBorderMode' x = case x of
   Reduce' -> 0x8016
   ConstantBorder' -> 0x8151
   ReplicateBorder' -> 0x8153

unmarshalConvolutionBorderMode' :: GLint -> ConvolutionBorderMode'
unmarshalConvolutionBorderMode' x
   | x == 0x8016 = Reduce'
   | x == 0x8151 = ConstantBorder'
   | x == 0x8153 = ReplicateBorder'
   | otherwise = error ("unmarshalConvolutionBorderMode': illegal value " ++ show x)

--------------------------------------------------------------------------------

data ConvolutionBorderMode =
     Reduce
   | ConstantBorder (Color4 GLfloat)
   | ReplicateBorder
   deriving ( Eq, Ord, Show )

--------------------------------------------------------------------------------

convolutionBorderMode :: ConvolutionTarget -> StateVar ConvolutionBorderMode
convolutionBorderMode t =
   makeStateVar (getConvolutionBorderMode t) (setConvolutionBorderMode t)

getConvolutionBorderMode :: ConvolutionTarget -> IO ConvolutionBorderMode
getConvolutionBorderMode t = do
   mode <- getConvolutionParameteri
              unmarshalConvolutionBorderMode' t ConvolutionBorderMode
   case mode of
      Reduce' -> return Reduce
      ConstantBorder' -> do
         c <- getConvolutionParameterC4f t ConvolutionBorderColor
         return $ ConstantBorder c
      ReplicateBorder' -> return ReplicateBorder

setConvolutionBorderMode :: ConvolutionTarget -> ConvolutionBorderMode -> IO ()
setConvolutionBorderMode t mode = do
   let setBM = setConvolutionParameteri
                  marshalConvolutionBorderMode' t ConvolutionBorderMode
   case mode of
      Reduce -> setBM Reduce'
      ConstantBorder c -> do
         setBM ConstantBorder'
         convolutionParameterC4f t ConvolutionBorderColor c
      ReplicateBorder -> setBM ReplicateBorder'

setConvolutionParameteri ::
   (a -> GLint) -> ConvolutionTarget -> ConvolutionParameter -> a -> IO ()
setConvolutionParameteri f t p x =
   glConvolutionParameteri
      (marshalConvolutionTarget t) (marshalConvolutionParameter p) (f x)

foreign import stdcall unsafe "dynamic" dyn_glConvolutionParameteri :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLint -> IO ()) ; glConvolutionParameteri :: (GLenum -> GLenum -> GLint -> IO ()) ; glConvolutionParameteri = dyn_glConvolutionParameteri ptr_glConvolutionParameteri ; ptr_glConvolutionParameteri :: FunPtr a ; ptr_glConvolutionParameteri = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glConvolutionParameteri")) ; {-# NOINLINE ptr_glConvolutionParameteri #-}

--------------------------------------------------------------------------------

convolutionFilterScale :: ConvolutionTarget -> StateVar (Color4 GLfloat)
convolutionFilterScale = convolutionC4f ConvolutionFilterScale

convolutionFilterBias :: ConvolutionTarget -> StateVar (Color4 GLfloat)
convolutionFilterBias = convolutionC4f ConvolutionFilterBias

convolutionC4f ::
   ConvolutionParameter -> ConvolutionTarget -> StateVar (Color4 GLfloat)
convolutionC4f p t =
   makeStateVar (getConvolutionParameterC4f t p) (convolutionParameterC4f t p)

getConvolutionParameterC4f ::
   ConvolutionTarget -> ConvolutionParameter -> IO (Color4 GLfloat)
getConvolutionParameterC4f t p =
   alloca $ \buf -> do
      glGetConvolutionParameterfv
         (marshalConvolutionTarget t) (marshalConvolutionParameter p) buf
      peek buf

foreign import stdcall unsafe "dynamic" dyn_glGetConvolutionParameterfv :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> Ptr (Color4 GLfloat) -> IO ()) ; glGetConvolutionParameterfv :: (GLenum -> GLenum -> Ptr (Color4 GLfloat) -> IO ()) ; glGetConvolutionParameterfv = dyn_glGetConvolutionParameterfv ptr_glGetConvolutionParameterfv ; ptr_glGetConvolutionParameterfv :: FunPtr a ; ptr_glGetConvolutionParameterfv = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glGetConvolutionParameterfv")) ; {-# NOINLINE ptr_glGetConvolutionParameterfv #-}

convolutionParameterC4f ::
   ConvolutionTarget -> ConvolutionParameter -> Color4 GLfloat -> IO ()
convolutionParameterC4f t p c =
   with c $
      glConvolutionParameterfv
         (marshalConvolutionTarget t) (marshalConvolutionParameter p)

foreign import stdcall unsafe "dynamic" dyn_glConvolutionParameterfv :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> Ptr (Color4 GLfloat) -> IO ()) ; glConvolutionParameterfv :: (GLenum -> GLenum -> Ptr (Color4 GLfloat) -> IO ()) ; glConvolutionParameterfv = dyn_glConvolutionParameterfv ptr_glConvolutionParameterfv ; ptr_glConvolutionParameterfv :: FunPtr a ; ptr_glConvolutionParameterfv = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_imaging") ("glConvolutionParameterfv")) ; {-# NOINLINE ptr_glConvolutionParameterfv #-}
