import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import { NavLink } from 'react-router-dom';

import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import DropDownFreeValue from '../../components/control/dropdown/DropDownFreeValue';
import RptAllEntryGuide from './RptAllEntryGuide';
import DailyListOrg from './DailyListOrg';
import DailyListItem from './DailyListItem';

// 予約状態選択肢
const rsvStatItems = [{ value: 1, name: 'キャンセル' }, { value: 2, name: '予約のみ' }, { value: 3, name: '受付済み' }];

// 受診状態選択肢
const rptStatItems = [{ value: 1, name: '未来院' }, { value: 2, name: '来院済み' }];

// 受診状態選択肢
const dailyPageMaxLineItems = [{ value: '*', name: '全データ' }, { value: 10, name: '10件ずつ' }, { value: 20, name: '20件ずつ' }, { value: 40, name: '40件ずつ' }];

// 検索条件入力エレメントの編集
class DailyListEditEntryCondition extends React.Component {
  // 「この日の操作」の編集
  editOperationMenu = (dtmStrDate, dtmEndDate) => {
    const { params, onOpenMntCapacityList, onOpenRptAllEntryGuide } = this.props;
    // 通常表示モード以外であれば編集しない
    if (params.print !== 0) return null;
    // 開始日のみ設定されている場合以外は編集しない
    if (!((dtmStrDate !== '') && (dtmEndDate === ''))) return null;

    return (
      <div style={{ border: '1px solid #cccccc', float: 'right' }}>
        <div style={{ float: 'left', backgroundColor: '#cccccc', lineHeight: '24px', textAlign: 'center', fontSize: '12px', color: '#ffffff', fontWeight: 'bolder' }}>この日の操作</div>
        <div style={{ float: 'left', backgroundColor: '#ffffff', marginTop: '1px' }}>
          <div style={{ float: 'left', marginLeft: '5px' }}>
            {/* 予約画面へのurl編集 */}
            <NavLink to="/contents/reserve/main" className="btn bgcolor_danger_light" title="新しく予約する">新しく予約</NavLink>
          </div>
          <div style={{ float: 'left' }}>
            {/* 当日ｉｄ発番画面へのurl編集 */}
            <a
              role="presentation"
              className="btn bgcolor_warning_light"
              style={{ cursor: 'pointer' }}
              title="当日ｉｄ発番処理"
              onClick={() => onOpenRptAllEntryGuide()}
            >
              当日ＩＤ発番
            </a>
          </div>
          <div style={{ float: 'left' }}>
            {/* 進捗画面へのurl編集 */}
            <a role="presentation" className="btn bgcolor_success" style={{ cursor: 'pointer' }} title="進捗を見る">進捗を見る</a>
          </div>
          <div style={{ float: 'left' }}>
            {/* アンカーの編集 */}
            <NavLink
              to="/contents/preference/schedule/capacity"
              role="presentation"
              className="btn bgcolor_aux_1"
              style={{ cursor: 'pointer' }}
              title="予約枠を見る"
              onClick={onOpenMntCapacityList(dtmStrDate)}
            >
              予約枠を見る
            </NavLink>
          </div>
        </div>
      </div>
    );
  }

  render() {
    const { params } = this.props;
    // 通常表示モード以外であれば編集しない
    if (params.print !== 0) return null;

    return (
      <div>
        <div style={{ marginTop: '4px' }}>
          <div style={{ width: '74px', float: 'left' }}>検索キー：</div>
          <div style={{ float: 'left' }}><Field name="key" component={TextBox} style={{ width: '240px' }} /></div>
          <div style={{ float: 'right' }}>{this.editOperationMenu(params.strDate, params.endDate)}</div>
          <div style={{ clear: 'both' }} />
        </div>
        <div style={{ marginTop: '4px' }}>
          <div style={{ float: 'left', width: '74px' }}>受診日：</div>
          <div style={{ float: 'left', marginRight: '10px' }}><Field name="strDate" component={DatePicker} /></div>
          <div style={{ float: 'left', marginRight: '10px' }}>～</div>
          <div style={{ float: 'left' }}><Field name="endDate" component={DatePicker} /></div>
          <div style={{ float: 'right' }}><Field name="csCd" component={DropDownCourse} addblank blankname="全てのコース" /></div>
          <div style={{ float: 'right' }}>コース：</div>
          <div style={{ clear: 'both' }} />
        </div>

        <div style={{ marginTop: '4px' }}>
          <div style={{ float: 'left' }}><DailyListOrg {...this.props} /></div>
          <div style={{ float: 'left' }}><DailyListItem {...this.props} /></div>
          <div style={{ clear: 'both' }} />
        </div>

        <div style={{ marginTop: '4px' }}>
          <div style={{ float: 'left' }}>予約状態：</div>
          <div style={{ float: 'left' }}><Field name="rsvStat" component={DropDown} items={rsvStatItems} addblank blankname="すべて" /></div>
          <div style={{ float: 'left', marginLeft: '20px' }}>受診状態：</div>
          <div style={{ float: 'left' }}><Field name="rptStat" component={DropDown} items={rptStatItems} addblank blankname="すべて" /></div>
          <div style={{ float: 'left', marginLeft: '20px' }}>受診区分：</div>
          <div style={{ float: 'left' }}><Field name="cslDivCd" component={DropDownFreeValue} freecd="CSLDIV" addblank blankname="すべて" /></div>
          <div style={{ float: 'left', marginLeft: '20px' }}><Field name="prtField" component={DropDownFreeValue} freecd="RSVLIST" namefield="freename" /></div>
          <div style={{ float: 'right' }}><Button className="btn" type="submit" value="表示" /></div>
          <div style={{ float: 'right', marginRight: '10px' }}><Field name="getCount" component={DropDown} items={dailyPageMaxLineItems} /></div>
          <div style={{ clear: 'both' }} />
        </div>
        <RptAllEntryGuide cslDate={params.strDate} />
      </div>
    );
  }
}

// propTypesの定義
DailyListEditEntryCondition.propTypes = {
  params: PropTypes.shape().isRequired,
  onOpenMntCapacityList: PropTypes.func.isRequired,
  onOpenRptAllEntryGuide: PropTypes.func.isRequired,
};

export default DailyListEditEntryCondition;
