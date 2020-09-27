import React from 'react';
import PropTypes from 'prop-types';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';

import { initializeFollowInfoList, getFollowItemInfoRequest, getTargetFollowListRequest, registerFollowInfoListRequest } from '../../modules/followup/followModule';
import { openUserGuide, closeUserGuide } from '../../modules/preference/hainsUserModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import GuideButton from '../../components/GuideButton';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import Chip from '../../components/Chip';
import UserGuide from '../common/UserGuide';

const formName = 'FollowInfoList';

const pageMaxLine = [
  { value: 10, name: '10行ずつ' },
  { value: 20, name: '20行ずつ' },
  { value: 50, name: '50行ずつ' },
  { value: 100, name: '100行ずつ' },
  { value: 9999, name: 'すべて' },
];

const equipStat = [
  { value: '', name: '' },
  { value: 0, name: '二次検査場所未定' },
  { value: 1, name: '当センター' },
  { value: 2, name: '本院・メディローカス' },
  { value: 3, name: '他院' },
  { value: 4, name: '対象外' },
  { value: 5, name: '未登録' },
];

const confirmStat = [
  { value: '', name: '' },
  { value: 0, name: '未承認' },
  { value: 1, name: '承認済み' },
];

class FollowInfoListHeader extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSelectedUserGuide = this.handleSelectedUserGuide.bind(this);
    this.handleEndCslDateClear = this.handleEndCslDateClear.bind(this);
    this.handleUserNameClear = this.handleUserNameClear.bind(this);
    this.handlePerNameClear = this.handlePerNameClear.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  handleEndCslDateClear() {
    const { setValue } = this.props;
    setValue('endCslDate', null);
  }

  handleUserNameClear() {
    const { setValue } = this.props;
    setValue('addUser', null);
    setValue('userName', null);
  }

  handlePerNameClear() {
    const { setValue } = this.props;
    setValue('perId', null);
    setValue('perName', null);
  }
  // ユーザ一覧明細のセット
  handleSelectedUserGuide(items) {
    const { setValue, onCloseUserGuide } = this.props;
    setValue('userName', items.username);
    setValue('updUser', items.userid);
    onCloseUserGuide();
  }

  // 検索ボタンを押下
  handleSubmit(values) {
    const { onSearch } = this.props;
    onSearch({ ...values, startPos: 1 });
  }

  render() {
    const { handleSubmit, onOpenGdeUserGuide, formValues, followItem, targetFollowList, onSave } = this.props;
    const itemCd = [];
    for (let i = 0; i < followItem.length; i += 1) {
      if (i === 0) {
        itemCd.push({ value: '', name: null });
      }
      itemCd.push({ value: followItem[i].itemcd, name: followItem[i].itemname });
    }
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <FieldGroup itemWidth={150}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Field name="startCslDate" component={DatePicker} id="startCslDate" />
              <Label>～</Label>
              <Field name="endCslDate" component={DatePicker} id="endCslDate" />
              <span><Chip onDelete={this.handleEndCslDateClear} /></span>
              <div style={{ marginLeft: '20px' }}>
                <Field name="pageMaxLine" component={DropDown} items={pageMaxLine} id="pageMaxLine" selectedValue="0" />
              </div>
              <Button style={{ marginLeft: '5px' }} onClick={() => this.handleSubmit(formValues)} value="検索" />
              <Button style={{ marginLeft: '5px' }} onClick={() => { onSave(formValues, targetFollowList); }} value="保存" />
            </FieldSet>
            <FieldSet>
              <FieldItem>検査項目</FieldItem>
              <Field name="judClassCd" component={DropDown} items={itemCd} id="judClassCd" />
            </FieldSet>
            <FieldSet>
              <FieldItem>二次検査施設区分</FieldItem>
              <Field name="equipDiv" component={DropDown} items={equipStat} id="equipDiv" />
            </FieldSet>
            <FieldSet>
              <FieldItem>結果承認状態</FieldItem>
              <Field name="confirmDiv" component={DropDown} items={confirmStat} id="confirmDiv" />
            </FieldSet>
            <FieldSet>
              <FieldItem>登録者</FieldItem>
              <GuideButton onClick={() => {
                onOpenGdeUserGuide();
              }}
              />
              <UserGuide onSelectRow={this.handleSelectedUserGuide} />
              <span><Chip onDelete={this.handleUserNameClear} /></span>
              <Field name="addUser" component="input" type="hidden" />
              <Label>{formValues && formValues.userName}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>個人ID</FieldItem>
              <GuideButton onClick={() => {
                  onOpenGdeUserGuide();
              }}
              />
              <UserGuide onSelectRow={this.handleSelectedUserGuide} />
              <span><Chip onDelete={this.handlePerNameClear} /></span>
              <Field name="perId" component="input" type="hidden" />
              <Label>{formValues && formValues.perName}</Label>
            </FieldSet>
          </FieldGroup>
        </div>
      </form>
    );
  }
}

const FollowInfoListHeaderFrom = reduxForm({
  form: formName,
})(FollowInfoListHeader);

// propTypesの定義
FollowInfoListHeader.propTypes = {
  onLoad: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  onSearch: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  onOpenGdeUserGuide: PropTypes.func.isRequired,
  onCloseUserGuide: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  followItem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  targetFollowList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

FollowInfoListHeader.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    followItem: state.app.followup.follow.followInfoList.followItem,
    targetFollowList: state.app.followup.follow.followInfoList.targetFollowList,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: () => {
    // 画面を初期化
    dispatch(initializeFollowInfoList());
    dispatch(getFollowItemInfoRequest());
  },

  onSearch: (params) => {
    dispatch(getTargetFollowListRequest(params));
  },

  onSave: (formValues, data) => {
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この内容で保存します。よろしいですか？')) {
      return;
    }
    const followResult = [];
    data.map((item, index) => (
      followResult.push({ RsvNo: item.webRsvNo, JudClassCd: item.judClassCd, SecEquipDiv: formValues[`equipDiv${index}`], JudCd: item.judCd })
    ));
    dispatch(registerFollowInfoListRequest({ data: { ...data, followResult }, formValues: { ...formValues, startPos: 1 } }));
  },
  onOpenGdeUserGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openUserGuide());
  },

  onCloseUserGuide: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeUserGuide());
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowInfoListHeaderFrom);
