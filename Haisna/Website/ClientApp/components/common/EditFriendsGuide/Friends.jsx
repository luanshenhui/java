/**
 * @file お連れ様情報更新ガイドのお連れ様情報
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';

// 共通モジュール
import CheckBox from '../../control/CheckBox';
import DropDown from '../../control/dropdown/DropDown';
import GuideButton from '../../GuideButton';
import Chip from '../../Chip';

class Friends extends React.Component {
  componentWillReceiveProps(nextProps) {
    const { fields, lines } = nextProps;
    // 受診者入力行数を指定行数まで追加
    if (fields.length < lines) {
      Array.from({ length: lines - fields.length }, () => fields.push());
    }
  }

  render() {
    const { fields, openGuide, change, compPerId } = this.props;
    return (
      <tbody>
        {
          fields.map((name, index) => {
            const rec = fields.get(index);

            // 受診者ガイドアイテム選択時処理
            const haindleOnSelectedItem = (item) => {
              const selectedItems = fields.getAll().filter((value) => value && value.perid === item.perid);
              // 既に選択されている場合は警告を表示
              if (selectedItems.length > 0) {
                // eslint-disable-next-line no-alert
                alert('すでに選択されています');
                return false;
              }
              // 変更前の同伴者個人IDをコピーしておく
              change(name, { ...item, compperidorg: item.compperid });
              return true;
            };

            // 行削除クリック処理
            const handleOnDeleteChip = () => {
              change(name, null);
            };

            // お連れ様情報のアイテム作成
            const items = rec ? fields.getAll().filter((value) => value && value.perid !== rec.perid)
              .map((value) => ({
                name: `${value.perid}${'　'}${value.name}`,
                value: value.perid,
              })) : [];

            // 同伴者判定
            const isCompanion = compPerId && rec && compPerId === rec.perid;
            // 受診者変更可否判定
            const canChange = index !== 0 && !isCompanion;

            return (
              <tr key={index.toString()}>
                <td>
                  {canChange && <GuideButton onClick={() => openGuide((selected) => haindleOnSelectedItem(selected))} />}
                  {isCompanion && '同伴者'}
                </td>
                <td>
                  {rec && (
                    canChange ? <Chip label={rec.perid} onDelete={() => handleOnDeleteChip()} /> : rec.perid
                  )}
                </td>
                <td>{rec && `${rec.name}（${rec.kananame}）`}</td>
                <td>{rec && rec.rsvno}</td>
                <td>{rec && rec.orgsname}</td>
                <td>{rec && rec.csname}</td>
                <td>{rec && rec.rsvgrpname}</td>
                <td><Field component={CheckBox} name={`${name}.samegrp1`} checkedValue={1} /></td>
                <td><Field component={CheckBox} name={`${name}.samegrp2`} checkedValue={1} /></td>
                <td><Field component={CheckBox} name={`${name}.samegrp3`} checkedValue={1} /></td>
                <td>{rec && <Field component={DropDown} name={`${name}.compperid`} items={items} addblank />}</td>
              </tr>
            );
          })
        }
      </tbody>
    );
  }
}
// prpoTypes定義
Friends.propTypes = {
  fields: PropTypes.shape().isRequired,
  lines: PropTypes.number.isRequired,
  openGuide: PropTypes.func.isRequired,
  change: PropTypes.func.isRequired,
  compPerId: PropTypes.string,
};

// defaultProps定義
Friends.defaultProps = {
  compPerId: null,
};

export default Friends;
