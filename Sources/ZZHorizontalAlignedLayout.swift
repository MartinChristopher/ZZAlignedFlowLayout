//
//  ZZHorizontalAlignedLayout.swift
//
//  水平滚动对齐

import UIKit

public enum ZZHorizontalAlignment {
    case left
    case center
    case right
}

public class ZZHorizontalAlignedLayout: UICollectionViewFlowLayout {
    
    public var alignment: ZZHorizontalAlignment = .left
    
    public override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              let attributesArray = super.layoutAttributesForElements(in: rect)?
                .map({ $0.copy() as! UICollectionViewLayoutAttributes }) else {
            return nil
        }
        var rows: [[UICollectionViewLayoutAttributes]] = []
        var currentRow: [UICollectionViewLayoutAttributes] = []
        var currentY: CGFloat = -1
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            if abs(attributes.frame.origin.y - currentY) > 1 {
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [attributes]
                currentY = attributes.frame.origin.y
            }
            else {
                currentRow.append(attributes)
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        for row in rows {
            let totalWidth = row.reduce(0) { $0 + $1.frame.width } + CGFloat(row.count - 1) * minimumLineSpacing
            let collectionWidth = collectionView.bounds.width
            var offsetX: CGFloat
            switch alignment {
            case .left:
                offsetX = sectionInset.left
            case .center:
                offsetX = max(sectionInset.left, (collectionWidth - totalWidth) / 2)
            case .right:
                offsetX = max(sectionInset.left, collectionWidth - sectionInset.right - totalWidth)
            }
            for attributes in row {
                var frame = attributes.frame
                frame.origin.x = offsetX
                attributes.frame = frame
                offsetX += frame.width + minimumLineSpacing
            }
        }
        return attributesArray
    }
    
}
