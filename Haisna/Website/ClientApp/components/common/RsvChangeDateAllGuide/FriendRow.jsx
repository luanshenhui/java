/**
 * @file 受診日一括変更ガイド テーブル行コンポーネント
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';

// 共通コンポーネント
import CheckBox from '../../control/CheckBox';
import DropDown from '../../control/dropdown/DropDown';

import { CONSULT_USED } from '../../../constants/common';

const FriendRow = ({ fields, start, count, mustChange }) => (
  <tbody>
    {
      fields.map((name, index) => {
        if (index >= start && (count === 0 || index < start + count)) {
          const { friend, rsvGrpItems, isTarget } = fields.get(index);

          // チェックボックスの表示状態を必要に応じて変える
          const ChangeChecBox = () => {
            if (friend.dayid) {
              return <span>受付済み</span>;
            }
            if (friend.cancelflg !== CONSULT_USED) {
              return <span>キャンセル</span>;
            }
            // この変数がtrueであることで更新対象と判定する
            // そのためこの条件が真になり何も表示されない場合は何かが間違っている
            if (!isTarget) {
              return null;
            }
            if (mustChange) {
              return <span>変更する</span>;
            }
            return <Field component={CheckBox} name={`${name}.isChange`} label="変更する" />;
          };

          return (
            <tr key={index.toString()}>
              <td><ChangeChecBox /></td>
              <td>{friend.perid}</td>
              <td>
                {(`${friend.lastname}${'　'}${friend.firstname}`).trim()}（{(`${friend.lastkname}${'　'}${friend.firstkname}`).trim()}）
              </td>
              <td>{friend.rsvno}</td>
              <td>{friend.orgsname}</td>
              <td>{friend.csname}</td>
              <td><Field component={DropDown} name={`${name}.friend.rsvgrpcd`} items={rsvGrpItems} addblank /></td>
            </tr>
          );
        }
        return null;
      })
    }
  </tbody>
);


FriendRow.propTypes = {
  fields: PropTypes.shape().isRequired,
  start: PropTypes.number,
  count: PropTypes.number,
  mustChange: PropTypes.bool,
};

FriendRow.defaultProps = {
  start: 0,
  count: 0,
  mustChange: false,
};

export default FriendRow;
