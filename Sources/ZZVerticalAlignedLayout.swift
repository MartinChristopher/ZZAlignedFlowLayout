//
//  ZZVerticalAlignedLayout.swift
//
//  竖直滚动对齐

import UIKit

public enum ZZVerticalAlignment {
    case left
    case center
    case right
}

public class ZZVerticalAlignedLayout: UICollectionViewFlowLayout {
    
    public var alignment: ZZVerticalAlignment = .left
    
    public override func prepare() {
        super.prepare()
        scrollDirection = .vertical
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              let attributesArray = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes }) else {
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
            var totalWidth: CGFloat = 0
            row.forEach { totalWidth += $0.frame.width }
            totalWidth += CGFloat(row.count - 1) * minimumInteritemSpacing
            let collectionWidth = collectionView.bounds.width
            var offsetX: CGFloat
            switch alignment {
            case .left:
                offsetX = sectionInset.left
            case .right:
                offsetX = collectionWidth - sectionInset.right - totalWidth
            case .center:
                offsetX = (collectionWidth - totalWidth) / 2
            }
            for attributes in row {
                attributes.frame.origin.x = offsetX
                offsetX += attributes.frame.width + minimumInteritemSpacing
            }
        }
        return attributesArray
    }
    
}
