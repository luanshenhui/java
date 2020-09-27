import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';

import moment from 'moment';

import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import Radio from '../../components/control/Radio';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';

import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';

import { initializeWebOrgRsvList, getWebOrgRsvListRequest, setOrgName } from '../../modules/reserve/webOrgRsvModule';

import OrgGuide from '../../containers/common/OrgGuide';
import { openOrgGuide } from '../../modules/preference/organizationModule';

// 状態
const regFlgItems = [{ value: 0, name: '指定なし' }, { value: 1, name: '未登録者' }, { value: 2, name: '編集済み受診者' }];
// 表示件数
const getCountItems = [{ value: 20, name: '20件ずつ' }, { value: 50, name: '50件ずつ' }, { value: 0, name: 'すべて' }];

const formName = 'webOrgRsvSearchHeader';

class WebOrgRsvSearchHeader extends React.Component {
  componentDidMount() {
    const { setValue } = this.props;

    const sysDate = moment().format('YYYY/MM/DD');
    setValue('strcsldate', sysDate);
    setValue('endcsldate', sysDate);
    setValue('key', '');
    setValue('opmode', 1);
    setValue('moushikbn', 1);
    setValue('order', 1);
  }

  render() {
    const { onOpenOrgGuide, orgname, setValue, onSetOrgName } = this.props;
    return (
      <ListHeaderFormBase {...this.props} >
        <Button type="submit" value="検 索" />

        <FieldGroup itemWidth={120}>
          <FieldSet>
            <FieldItem>受診日</FieldItem>
            <Field name="strcsldate" component={DatePicker} />
            <Label>～</Label>
            <Field name="endcsldate" component={DatePicker} />
          </FieldSet>
          <FieldSet>
            <FieldItem>検索キー</FieldItem>
            <Field name="key" component="input" type="text" style={{ width: 290 }} />
          </FieldSet>
          <FieldSet>
            <FieldItem>処理日</FieldItem>
            <Field name="stropdate" component={DatePicker} />
            <Label>～</Label>
            <Field name="endopdate" component={DatePicker} />
          </FieldSet>
          <FieldSet>
            <div style={{ marginLeft: 120 }}>
              <Field component={Radio} name="opmode" checkedValue={1} label="申込日で検索" />
              <Field component={Radio} name="opmode" checkedValue={2} label="予約処理日で検索" />
            </div>
          </FieldSet>
          <FieldSet>
            <FieldItem>受診団体</FieldItem>
            <OrgGuide
              onSelected={(selectedItem) => {
                onSetOrgName(selectedItem.org.orgname);
                setValue('orgcd1', selectedItem.org.orgcd1);
                setValue('orgcd2', selectedItem.org.orgcd1);
              }}
            />
            <GuideButton
              onClick={() => {
                onOpenOrgGuide();
              }}
            />
            {orgname && (
              <Chip
                label={orgname}
                onDelete={() => {
                  onSetOrgName(null);
                  setValue('orgcd1', '');
                  setValue('orgcd2', '');
                }}
              />
            )}
          </FieldSet>
          <FieldSet>
            <FieldItem>状態</FieldItem>
            <Field name="regFlg" component={DropDown} items={regFlgItems} />
          </FieldSet>
          <FieldSet>
            <FieldItem>申込区分</FieldItem>
            <Field component={Radio} name="moushikbn" checkedValue={0} label="すべて" />
            <Field component={Radio} name="moushikbn" checkedValue={1} label="新規" />
            <Field component={Radio} name="moushikbn" checkedValue={2} label="キャンセル" />
          </FieldSet>
          <FieldSet>
            <FieldItem>出力順</FieldItem>
            <Field component={Radio} name="order" checkedValue={1} label="受診日順" />
            <Field component={Radio} name="order" checkedValue={2} label="個人ＩＤ順" />
          </FieldSet>
          <FieldSet>
            <FieldItem>&nbsp;</FieldItem>
            <Field name="limit" component={DropDown} items={getCountItems} />
          </FieldSet>
        </FieldGroup>
      </ListHeaderFormBase>
    );
  }
}

const WebOrgRsvSearchHeaderForm = reduxForm({
  form: formName,
})(WebOrgRsvSearchHeader);

// propTypesの定義
WebOrgRsvSearchHeader.propTypes = {
  onOpenOrgGuide: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  onSetOrgName: PropTypes.func.isRequired,
  orgname: PropTypes.string.isRequired,
};

const mapStateToProps = (state) => (
  {
    orgname: state.app.reserve.webOrgRsv.webOrgRsvSearch.orgname,
  }
);

const mapDispatchToProps = (dispatch) => ({
  initializeList: () => {
    dispatch(initializeWebOrgRsvList());
  },
  setValue: (name, value) => {
    dispatch(blur(formName, name, value));
  },
  onSearch: (conditions) => {
    const [page, limit] = [1, 20];
    dispatch(getWebOrgRsvListRequest({ page, limit, ...conditions }));
  },
  onOpenOrgGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openOrgGuide());
  },
  onSetOrgName: (orgname) => {
    dispatch(setOrgName({ orgname }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvSearchHeaderForm));
