module World 
( World(..),
  Box(..),
  createWorld,
  createBox) where

import qualified Data.Text as T              (Text, unpack, length) 
import           Graphics.Gloss.Data.Picture (Picture(..))
import           Graphics.Gloss.Data.Color   (makeColor)
import           GHC.Float                   (float2Double)
import qualified Physics.Hipmunk        as H (Body, newBody,
                                              newShape, ShapeType(..),
                                              Vector(..), Space,
                                              newSpace)
import Consts                                (fontScale, screenWidth)

data World = World {
  boxes :: [Box],
  space :: !H.Space
}


data Box = Box {
  picture :: !Picture,
  body    :: !H.Body
}

createBox :: T.Text -> IO Box
createBox t = do
  magnificentBody <- H.newBody 20 2
  H.newShape magnificentBody (H.Polygon boxVertices) (H.Vector 0 0)
  return $ Box boxPic magnificentBody
  where
    boxVertices   = [(H.Vector (-boxWidthD) boxHeightD), (H.Vector boxWidthD boxHeightD), (H.Vector boxWidthD (-boxHeightD)), (H.Vector (-boxWidthD) (-boxHeightD))]
    boxPic        = Translate (screenWidth / 2) 0 $ Pictures [boxGeo, boxText]
    boxText       = Translate (-8) (-25) $ Scale fontScale fontScale $ Color (makeColor 0 0 0 255) $ Text $ T.unpack t
    boxGeo        = Scale (fontScale * 2) (fontScale * 2) $ Color (makeColor 255 255 255 255) $ Polygon [(-boxWidth,boxHeight),(boxWidth,boxHeight),(boxWidth,-boxHeight),(-boxWidth,-boxHeight)]
    boxHeightD    = float2Double boxHeight
    boxWidthD     = float2Double boxWidth
    boxHeight     = 35.0
    boxWidth      = 20 + 15.0 * fromIntegral (T.length t)

createWorld :: IO World
createWorld = do
  s <- H.newSpace
  return $ World [] s
